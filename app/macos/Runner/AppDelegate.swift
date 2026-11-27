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
    "mp4", "mov", "m4v", "mkv", "webm", "avi",
  ]
  private static let transcodeImageExts: Set<String> = [
    "heic", "heif", "bmp", "tif", "tiff", "gif",
  ]

  override func applicationDidFinishLaunching(_ notification: Notification) {
    super.applicationDidFinishLaunching(notification)
    cleanupStaleIncomingDirs()
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
    let launchDir = URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      .appendingPathComponent("incoming", isDirectory: true)
      .appendingPathComponent(launchId, isDirectory: true)

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
      let values = try? url.resourceValues(forKeys: [.isRegularFileKey]),
      values.isRegularFile == true
    else { return nil }
    let ext = url.pathExtension.lowercased()
    if passthroughExts.contains(ext) {
      return url.path
    }
    guard transcodeImageExts.contains(ext) else { return nil }
    // CoreImage is thread-safe, preserves full native pixel dimensions regardless
    // of DPI, and bakes EXIF orientation into the transcoded JPEG.
    guard let ciImage = CIImage(contentsOf: url, options: [.applyOrientationProperty: true]) else {
      return nil
    }
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let dst = dir.appendingPathComponent("\(UUID().uuidString).jpg")
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) ?? CGColorSpaceCreateDeviceRGB()
    do {
      try ciContext.writeJPEGRepresentation(
        of: ciImage,
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
