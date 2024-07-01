import UIKit
import SwiftUI

//class SceneDelegate: UIResponder, UIWindowSceneDelegate {
//    var window: UIWindow?
//
//    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        NSLog("[martin] scene:willConnectTo:options")
//        let contentView = LoadingView()
//
//        if let windowScene = scene as? UIWindowScene {
//            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
//            self.window = window
//            window.makeKeyAndVisible()
//        }
//    }
//
//    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        NSLog("[martin] scene:openURLContexts")
//        guard let urlContext = URLContexts.first else { return }
//        let url = urlContext.url
//        
//        if url.scheme == "futuremagazine" {
//            // URL을 처리하는 로직을 여기에 작성합니다.
//            print("URL received in SceneDelegate: \(url)")
//            // 필요한 경우 URL의 path 또는 query parameters를 분석할 수 있습니다.
//        }
//    }
//}
