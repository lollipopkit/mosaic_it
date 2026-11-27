import Flutter
import Photos
import PhotosUI
import UIKit
import UniformTypeIdentifiers

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate, PHPickerViewControllerDelegate, UIAdaptivePresentationControllerDelegate {
  private var platformChannel: FlutterMethodChannel?
  private var dartReady = false
  private var pendingIncoming: [String] = []
  private var activePickerResult: FlutterResult?
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

  private var launchIncomingDir: URL {
    URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      .appendingPathComponent("incoming", isDirectory: true)
      .appendingPathComponent(launchId, isDirectory: true)
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
    let launchDir = launchIncomingDir

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

  private func presentMediaPicker(
    multiple: Bool,
    allowVideo: Bool,
    result: @escaping FlutterResult
  ) {
    guard activePickerResult == nil else {
      result([String]())
      return
    }
    guard let presenter = Self.topViewController() else {
      result([String]())
      return
    }
    // Zero-permission PHPickerViewController (no PHPhotoLibrary.shared(), no AVCaptureDevice).
    var config = PHPickerConfiguration()
    config.selectionLimit = multiple ? 0 : 1
    config.filter = allowVideo ? .any(of: [.images, .videos]) : .images
    config.preferredAssetRepresentationMode = .current
    let picker = PHPickerViewController(configuration: config)
    picker.delegate = self
    picker.presentationController?.delegate = self
    activePickerResult = result
    presenter.present(picker, animated: true)
  }

  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    guard let flutterResult = activePickerResult else { return }
    activePickerResult = nil
    flutterResult([String]())
  }

  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    picker.dismiss(animated: true)
    guard let flutterResult = activePickerResult else { return }
    activePickerResult = nil
    if results.isEmpty {
      flutterResult([String]())
      return
    }

    let launchDir = launchIncomingDir
    let group = DispatchGroup()
    let lock = NSLock()
    var resolved = Array<String?>(repeating: nil, count: results.count)

    for (index, item) in results.enumerated() {
      let provider = item.itemProvider
      // Check image before movie so composite media (e.g. Live Photos) stay images.
      let isImage = provider.hasItemConformingToTypeIdentifier(UTType.image.identifier)
      let isMovie = !isImage && provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier)
      guard isImage || isMovie else { continue }
      let typeId = isImage ? UTType.image.identifier : UTType.movie.identifier
      let suggested = provider.suggestedName

      group.enter()
      provider.loadFileRepresentation(forTypeIdentifier: typeId) { [weak self] url, _ in
        defer { group.leave() }
        guard let self, let url else { return }
        // Serialize decoding/transcoding inside an autoreleasepool so large HEIC
        // batches keep peak memory bounded to a single image while url stays valid.
        let outPath: String? = self.incomingQueue.sync {
          autoreleasepool {
            if isMovie {
              return Self.copyMovieToIncoming(url, suggestedStem: suggested, in: launchDir)
            }
            return Self.copyOrTranscodeToIncoming(
              url,
              in: launchDir,
              copyNative: true,
              suggestedStem: suggested
            )
          }
        }
        if let outPath {
          lock.lock()
          resolved[index] = outPath
          lock.unlock()
        }
      }
    }

    group.notify(queue: .main) {
      flutterResult(resolved.compactMap { $0 })
    }
  }

  private static func topViewController() -> UIViewController? {
    let scenes = UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .filter { $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive }
    guard let root = scenes.first?.windows.first(where: \.isKeyWindow)?.rootViewController
      ?? scenes.first?.windows.first?.rootViewController
    else { return nil }
    var top = root
    while let presented = top.presentedViewController {
      top = presented
    }
    return top
  }

  private static func copyMovieToIncoming(
    _ url: URL,
    suggestedStem: String?,
    in dir: URL
  ) -> String? {
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let rawExt = sanitizeExtension(url.pathExtension)
    let ext = rawExt.isEmpty ? "mov" : rawExt
    let stem = sanitizeStem(suggestedStem ?? url.deletingPathExtension().lastPathComponent)
    let dst = dir.appendingPathComponent(uniqueFileName(stem: stem, ext: ext))
    do {
      try FileManager.default.copyItem(at: url, to: dst)
      return dst.path
    } catch {
      try? FileManager.default.removeItem(at: dst)
      return nil
    }
  }

  private static func copyOrTranscodeToIncoming(
    _ url: URL,
    in dir: URL,
    copyNative: Bool = true,
    suggestedStem: String? = nil
  ) -> String? {
    guard
      let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
      values.isRegularFile == true
    else { return nil }
    if let size = values.fileSize, Int64(size) > maxIncomingBytes {
      return nil
    }
    let stem = sanitizeStem(suggestedStem ?? url.deletingPathExtension().lastPathComponent)
    let ext = sanitizeExtension(url.pathExtension)
    if nativeImageExts.contains(ext) {
      if !copyNative { return url.path }
      try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
      let dst = dir.appendingPathComponent(uniqueFileName(stem: stem, ext: ext))
      do {
        try FileManager.default.copyItem(at: url, to: dst)
        return dst.path
      } catch {
        try? FileManager.default.removeItem(at: dst)
        return nil
      }
    }
    // Transcode HEIC / TIFF / BMP / GIF (and bake EXIF orientation) so the Rust
    // image decoder only receives upright full-resolution 8-bit sRGB JPEG pixels.
    guard
      let rawData = try? Data(contentsOf: url),
      let image = UIImage(data: rawData)
    else { return nil }
    let format = UIGraphicsImageRendererFormat()
    format.scale = image.scale
    format.opaque = true
    format.preferredRange = .standard
    let renderer = UIGraphicsImageRenderer(size: image.size, format: format)
    let upright = renderer.image { ctx in
      // Composite transparent images over white so dark text remains readable.
      UIColor.white.setFill()
      ctx.fill(CGRect(origin: .zero, size: image.size))
      image.draw(in: CGRect(origin: .zero, size: image.size))
    }
    guard let jpeg = upright.jpegData(compressionQuality: 0.95) else { return nil }
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let dst = dir.appendingPathComponent(uniqueFileName(stem: stem, ext: "jpg"))
    do {
      try jpeg.write(to: dst, options: .atomic)
      return dst.path
    } catch {
      try? FileManager.default.removeItem(at: dst)
      return nil
    }
  }

  private static func saveImageToPhotos(path: String, completion: @escaping (Bool) -> Void) {
    let url = URL(fileURLWithPath: path)
    guard FileManager.default.fileExists(atPath: url.path) else {
      completion(false)
      return
    }
    // Write-only authorization: pairs with NSPhotoLibraryAddUsageDescription only.
    PHPhotoLibrary.requestAuthorization(for: .addOnly) { status in
      guard status == .authorized || status == .limited else {
        completion(false)
        return
      }
      PHPhotoLibrary.shared().performChanges({
        PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: url)
      }) { success, _ in
        completion(success)
      }
    }
  }

  private static func sanitizeExtension(_ raw: String) -> String {
    let cleaned = raw.lowercased().filter { $0.isASCII && ($0.isLetter || $0.isNumber) }
    return String(cleaned.prefix(8))
  }

  private static func sanitizeStem(_ raw: String) -> String {
    let cleaned = raw.filter { $0.isASCII && ($0.isLetter || $0.isNumber || $0 == "-" || $0 == "_") }
    let trimmed = String(cleaned.prefix(40))
    return trimmed.isEmpty ? "image" : trimmed
  }

  private static func uniqueFileName(stem: String, ext: String) -> String {
    let suffix = String(UUID().uuidString.prefix(8)).lowercased()
    return "\(stem)-\(suffix).\(ext)"
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
      case "pickMedia":
        guard let self else {
          result([String]())
          return
        }
        let args = call.arguments as? [String: Any]
        let multiple = args?["multiple"] as? Bool ?? true
        let allowVideo = args?["allowVideo"] as? Bool ?? true
        self.presentMediaPicker(multiple: multiple, allowVideo: allowVideo, result: result)
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
      case "saveImage":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String
        else {
          result(false)
          return
        }
        Self.saveImageToPhotos(path: path) { ok in
          DispatchQueue.main.async { result(ok) }
        }
      case "prepareImage":
        guard
          let self,
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String
        else {
          result(nil)
          return
        }
        let launchDir = self.launchIncomingDir
        let url = URL(fileURLWithPath: path)
        self.incomingQueue.async {
          let prepared = Self.copyOrTranscodeToIncoming(url, in: launchDir, copyNative: false)
          DispatchQueue.main.async { result(prepared) }
        }
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
