import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    FlutterMethodChannel(
      name: "com.lollipopkit.unseen/app_icon",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
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
  }
}
