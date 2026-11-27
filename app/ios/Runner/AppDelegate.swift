import Flutter
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private var platformChannel: FlutterMethodChannel?
  private var dartReady = false
  private var pendingIncoming: [String] = []
  private let launchId = UUID().uuidString
  private let incomingQueue = DispatchQueue(
    label: "com.lollipopkit.unseen.incoming",
    qos: .userInitiated
  )

  private static let nativeImageExts: Set<String> = ["png", "jpg", "jpeg", "webp"]
  private static let maxIncomingBytes: Int64 = 256 * 1024 * 1024

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    cleanupStaleIncomingDirs()
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func cleanupStaleIncomingDirs() {
    let keep = launchId
    incomingQueue.async {
      let root = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        .appendingPathComponent("incoming", isDirectory: true)
      guard let entries = try? FileManager.default.contentsOfDirectory(
        at: root,
        includingPropertiesForKeys: nil
      ) else { return }
      for entry in entries where entry.lastPathComponent != keep {
        try? FileManager.default.removeItem(at: entry)
      }
    }
  }

  func enqueueIncomingURLs(_ urls: [URL]) {
    let fileURLs = urls.filter(\.isFileURL)
    guard !fileURLs.isEmpty else { return }
    let scoped = fileURLs.map { ($0, $0.startAccessingSecurityScopedResource()) }
    let launchDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      .appendingPathComponent("incoming", isDirectory: true)
      .appendingPathComponent(launchId, isDirectory: true)

    incomingQueue.async { [weak self] in
      var copied: [String] = []
      for (url, granted) in scoped {
        defer { if granted { url.stopAccessingSecurityScopedResource() } }
        if let path = Self.copyOrTranscodeToIncoming(url, in: launchDir) {
          copied.append(path)
        }
      }
      guard !copied.isEmpty else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        if self.dartReady, let ch = self.platformChannel {
          ch.invokeMethod("onIncomingFiles", arguments: copied)
        } else {
          self.pendingIncoming.append(contentsOf: copied)
        }
      }
    }
  }

  private static func copyOrTranscodeToIncoming(_ url: URL, in dir: URL) -> String? {
    guard
      let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
      values.isRegularFile == true
    else { return nil }
    if let size = values.fileSize, Int64(size) > maxIncomingBytes {
      return nil
    }
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let ext = sanitizeExtension(url.pathExtension)
    if nativeImageExts.contains(ext) {
      let dst = dir.appendingPathComponent("\(UUID().uuidString).\(ext)")
      do {
        try FileManager.default.copyItem(at: url, to: dst)
        return dst.path
      } catch {
        try? FileManager.default.removeItem(at: dst)
        return nil
      }
    }
    // Transcode HEIC / TIFF / BMP / GIF (and bake EXIF orientation) so the Rust
    // image decoder only receives upright full-resolution JPEG pixels.
    // Loading via Data avoids UIImage(contentsOfFile:) interpreting @2x/@3x filenames.
    guard
      let rawData = try? Data(contentsOf: url),
      let image = UIImage(data: rawData)
    else { return nil }
    let format = UIGraphicsImageRendererFormat()
    format.scale = image.scale
    format.opaque = true
    let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
    let upright = renderer.image { _ in
      image.draw(in: CGRect(origin: .zero, size: image.size))
    }
    guard let jpeg = upright.jpegData(compressionQuality: 0.95) else { return nil }
    let dst = dir.appendingPathComponent("\(UUID().uuidString).jpg")
    do {
      try jpeg.write(to: dst, options: .atomic)
      return dst.path
    } catch {
      try? FileManager.default.removeItem(at: dst)
      return nil
    }
  }

  private static func sanitizeExtension(_ raw: String) -> String {
    let cleaned = raw.lowercased().filter { $0.isASCII && ($0.isLetter || $0.isNumber) }
    return String(cleaned.prefix(8))
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    let messenger = engineBridge.applicationRegistrar.messenger()

    FlutterMethodChannel(
      name: "com.lollipopkit.unseen/app_icon",
      binaryMessenger: messenger
    ).setMethodCallHandler { call, result in
      // Every icon set is named AppIcon-<name>.
      let prefix = "AppIcon-"
      let icons = Bundle.main.object(forInfoDictionaryKey: "CFBundleIcons") as? [String: Any]
      let primary = (icons?["CFBundlePrimaryIcon"] as? [String: Any])?["CFBundleIconName"] as? String
      switch call.method {
      case "get":
        result((UIApplication.shared.alternateIconName ?? primary).map { String($0.dropFirst(prefix.count)) })
      case "set":
        let alternates = icons?["CFBundleAlternateIcons"] as? [String: Any] ?? [:]
        let name = prefix + (call.arguments as? String ?? "")
        guard name == primary || alternates[name] != nil else {
          result(FlutterError(code: "app_icon", message: "No app icon named \(name)", details: nil))
          return
        }
        UIApplication.shared.setAlternateIconName(name == primary ? nil : name) { error in
          DispatchQueue.main.async {
            result(error.map { FlutterError(code: "app_icon", message: $0.localizedDescription, details: nil) })
          }
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    let channel = FlutterMethodChannel(
      name: "com.lollipopkit.unseen/platform",
      binaryMessenger: messenger
    )
    platformChannel = channel
    channel.setMethodCallHandler { [weak self] call, result in
      switch call.method {
      case "copyImage":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String,
          let data = try? Data(contentsOf: URL(fileURLWithPath: path))
        else {
          result(false)
          return
        }
        let ext = (path as NSString).pathExtension.lowercased()
        let typeId = (ext == "jpg" || ext == "jpeg") ? UTType.jpeg.identifier : UTType.png.identifier
        UIPasteboard.general.setData(data, forPasteboardType: typeId)
        result(true)
      case "getIncomingFiles":
        self?.dartReady = true
        let items = self?.pendingIncoming ?? []
        self?.pendingIncoming.removeAll()
        result(items)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }
}
