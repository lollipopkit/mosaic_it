import Cocoa
import CoreImage
import FlutterMacOS
import ImageIO

@main
class AppDelegate: FlutterAppDelegate {
  var platformChannel: FlutterMethodChannel?
  var dartReady = false
  var pendingIncoming: [String] = []

  private let launchId = UUID().uuidString
  private let incomingQueue = DispatchQueue(
    label: "com.lollipopkit.unseen.incoming",
    qos: .userInitiated
  )
  private static let ciContext = CIContext()

  private static let passthroughExts: Set<String> = [
    "png", "jpg", "jpeg", "webp",
    "mp4", "mov", "m4v", "mkv", "webm", "avi", "3gp", "3g2", "mpg", "mpeg", "ts",
  ]
  private static let maxIncomingBytes: Int64 = 256 * 1024 * 1024

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    cleanupStaleIncomingDirs()
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

  func prepareImagePath(_ path: String, completion: @escaping (String?) -> Void) {
    let launchDir = launchIncomingDir
    let url = URL(fileURLWithPath: path)
    incomingQueue.async {
      let resolved = Self.prepareIncoming(url, in: launchDir)
      DispatchQueue.main.async { completion(resolved) }
    }
  }

  func enqueueIncomingURLs(_ urls: [URL]) {
    let fileURLs = urls.filter(\.isFileURL)
    guard !fileURLs.isEmpty else { return }
    let launchDir = launchIncomingDir

    incomingQueue.async { [weak self] in
      let resolved = fileURLs.compactMap { Self.prepareIncoming($0, in: launchDir) }
      guard !resolved.isEmpty else { return }
      DispatchQueue.main.async { [weak self] in
        guard let self else { return }
        if self.dartReady, let ch = self.platformChannel {
          ch.invokeMethod("onIncomingFiles", arguments: resolved)
        } else {
          self.pendingIncoming.append(contentsOf: resolved)
        }
      }
    }
  }

  private static func prepareIncoming(_ url: URL, in dir: URL) -> String? {
    guard
      let values = try? url.resourceValues(forKeys: [.isRegularFileKey, .fileSizeKey]),
      values.isRegularFile == true
    else { return nil }
    let ext = url.pathExtension.lowercased()
    if passthroughExts.contains(ext) {
      return url.path
    }
    if let size = values.fileSize, Int64(size) > maxIncomingBytes {
      return nil
    }
    // CoreImage is thread-safe, handles HEIC/TIFF/BMP/GIF (including extensionless files),
    // preserves full pixel dimensions, and bakes EXIF orientation.
    guard let ciImage = CIImage(contentsOf: url, options: [.applyOrientationProperty: true]) else {
      return nil
    }
    // Composite over white so transparent PNG/GIF/TIFF regions do not turn black in JPEG.
    let white = CIImage(color: .white).cropped(to: ciImage.extent)
    let composited = ciImage.composited(over: white)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let stem = sanitizeStem(url.deletingPathExtension().lastPathComponent)
    let suffix = String(UUID().uuidString.prefix(8)).lowercased()
    let dst = dir.appendingPathComponent("\(stem)-\(suffix).jpg")
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
    do {
      try ciContext.writeJPEGRepresentation(
        of: composited,
        to: dst,
        colorSpace: colorSpace,
        options: [kCGImageDestinationLossyCompressionQuality as CIImageRepresentationOption: 0.95]
      )
      return dst.path
    } catch {
      try? FileManager.default.removeItem(at: dst)
      return nil
    }
  }

  private static func sanitizeStem(_ raw: String) -> String {
    let cleaned = raw.filter { $0.isASCII && ($0.isLetter || $0.isNumber || $0 == "-" || $0 == "_") }
    let trimmed = String(cleaned.prefix(40))
    return trimmed.isEmpty ? "image" : trimmed
  }

  override func application(_ application: NSApplication, open urls: [URL]) {
    let fileURLs = urls.filter(\.isFileURL)
    if !fileURLs.isEmpty {
      enqueueIncomingURLs(fileURLs)
    }
    let otherURLs = urls.filter { !$0.isFileURL }
    if !otherURLs.isEmpty {
      super.application(application, open: otherURLs)
    }
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }

  override func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
    return true
  }
}
