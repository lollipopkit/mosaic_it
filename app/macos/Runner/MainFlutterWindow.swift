import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow, NSDraggingDestination {
  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)
    setupPlatformChannel(messenger: flutterViewController.engine.binaryMessenger)
    registerForDraggedTypes([.fileURL])

    super.awakeFromNib()
  }

  private func setupPlatformChannel(messenger: FlutterBinaryMessenger) {
    let channel = FlutterMethodChannel(
      name: "com.lollipopkit.unseen/platform",
      binaryMessenger: messenger
    )
    let appDelegate = NSApp.delegate as? AppDelegate
    appDelegate?.platformChannel = channel
    channel.setMethodCallHandler { [weak appDelegate] call, result in
      switch call.method {
      case "copyImage":
        guard
          let args = call.arguments as? [String: Any],
          let path = args["path"] as? String
        else {
          result(false)
          return
        }
        result(Self.copyImageToPasteboard(path: path))
      case "getIncomingFiles":
        appDelegate?.dartReady = true
        let items = appDelegate?.pendingIncoming ?? []
        appDelegate?.pendingIncoming.removeAll()
        result(items)
      default:
        result(FlutterMethodNotImplemented)
      }
    }
  }

  private static func copyImageToPasteboard(path: String) -> Bool {
    let url = URL(fileURLWithPath: path)
    guard
      let data = try? Data(contentsOf: url),
      let image = NSImage(data: data)
    else { return false }

    let item = NSPasteboardItem()
    let ext = url.pathExtension.lowercased()
    if ext == "png" {
      item.setData(data, forType: .png)
    } else if
      let tiff = image.tiffRepresentation,
      let rep = NSBitmapImageRep(data: tiff),
      let png = rep.representation(using: .png, properties: [:])
    {
      item.setData(png, forType: .png)
    }
    if let tiff = image.tiffRepresentation {
      item.setData(tiff, forType: .tiff)
    }

    let pb = NSPasteboard.general
    pb.clearContents()
    return pb.writeObjects([item])
  }

  func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
    return Self.supportedURLs(from: sender).isEmpty ? [] : .copy
  }

  func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
    let urls = Self.supportedURLs(from: sender)
    guard !urls.isEmpty else { return false }
    (NSApp.delegate as? AppDelegate)?.enqueueIncomingURLs(urls)
    return true
  }

  private static func supportedURLs(from info: NSDraggingInfo) -> [URL] {
    let allowed: Set<String> = [
      "png", "jpg", "jpeg", "webp", "heic", "heif", "bmp", "tif", "tiff", "gif",
      "mp4", "mov", "m4v", "mkv", "webm", "avi",
    ]
    let urls = info.draggingPasteboard.readObjects(
      forClasses: [NSURL.self],
      options: [.urlReadingFileURLsOnly: true]
    ) as? [URL] ?? []
    return urls.filter { url in
      guard allowed.contains(url.pathExtension.lowercased()) else { return false }
      return (try? url.resourceValues(forKeys: [.isRegularFileKey]).isRegularFile) == true
    }
  }
}
