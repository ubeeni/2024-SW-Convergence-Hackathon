import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var launchURL: URL?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // SwiftUI ContentView 로드
        let contentView = ContentView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }

        // 앱이 처음 실행될 때, 딥링크 URL이 있는지 확인
        if let url = connectionOptions.urlContexts.first?.url {
            print("SceneDelegate received URL at launch: \(url)")
            // launchURL에 URL 저장
            launchURL = url
            // 딥링크 알림 게시
            NotificationCenter.default.post(name: .handleDeepLink, object: url)
        }
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        print("SceneDelegate received URL: \(url)")
        
        // 딥링크 알림 게시
        NotificationCenter.default.post(name: .handleDeepLink, object: url)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // 이 메서드는 장면이 세션에서 해제될 때 호출됩니다.
        // 장면이 다시 연결되지 않을 수도 있는 이 시점에서 모든 리소스를 해제합니다.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // 이 메서드는 장면이 활성 상태가 될 때 호출됩니다.
        // 이 시점에서 일시 중지된(또는 아직 시작되지 않은) 작업을 다시 시작합니다.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // 이 메서드는 장면이 활성 상태를 잃고 일시 중지 상태가 되기 직전에 호출됩니다.
        // 발생할 수 있는 일시 중단을 처리하는 데 사용됩니다.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // 이 메서드는 장면이 백그라운드에서 포그라운드로 전환되기 직전에 호출됩니다.
        // 이 시점에서 백그라운드로 이동하면서 변경된 상태를 복구합니다.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // 이 메서드는 장면이 백그라운드로 전환될 때 호출됩니다.
        // 이 시점에서 백그라운드로 전환된 상태를 저장하고, 필요에 따라 작업을 일시 중지합니다.
    }
}
extension Notification.Name {
    static let handleDeepLink = Notification.Name("handleDeepLink")
}
