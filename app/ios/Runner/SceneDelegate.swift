import Flutter
import UIKit

class SceneDelegate: FlutterSceneDelegate {
  override func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    super.scene(scene, willConnectTo: session, options: connectionOptions)
    let urls = connectionOptions.urlContexts.map(\.url).filter(\.isFileURL)
    if !urls.isEmpty, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.enqueueIncomingURLs(urls)
    }
  }

  override func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    let fileURLs = URLContexts.map(\.url).filter(\.isFileURL)
    if !fileURLs.isEmpty, let appDelegate = UIApplication.shared.delegate as? AppDelegate {
      appDelegate.enqueueIncomingURLs(fileURLs)
    }
    let otherContexts = URLContexts.filter { !$0.url.isFileURL }
    if !otherContexts.isEmpty {
      super.scene(scene, openURLContexts: otherContexts)
    }
  }
}
