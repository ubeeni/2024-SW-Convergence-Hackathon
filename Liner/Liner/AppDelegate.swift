//
//  AppDelegate.swift
//  Liner
//
//  Created by ram on 8/24/24.
//
import Foundation
import SwiftUI
import Firebase
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // 파이어베이스 설정
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { granted, error in
                if let error = error {
                    print("Notification permission error: \(error.localizedDescription)")
                }
                if granted {
                    DispatchQueue.main.async {
                        application.registerForRemoteNotifications()
                    }
                } else {
                    print("User denied notification permissions")
                }
            }
        )
        
        // 파이어베이스 Messaging 설정
        Messaging.messaging().delegate = self
        
        return true
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // APNs 등록 성공 시 호출
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("APNS token: \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // APNs 등록 실패 시 호출
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications: \(error.localizedDescription)")
    }
    
    // Foreground(앱 켜진 상태)에서 알림을 수신할 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 실행 중일 때도 알림이 화면에 표시되도록 설정
        completionHandler([.list, .banner, .sound, .badge])
    }
    
    // Background에서 알림을 탭했을 때 호출
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        print("User tapped on notification: \(response.notification.request.content.userInfo)")

        // 알림의 userInfo에서 딥링크 URL을 추출하여 처리
        if let deepLinkString = response.notification.request.content.userInfo["deep_link"] as? String,
           let deepLinkURL = URL(string: deepLinkString) {
            // 딥링크 URL을 NotificationCenter를 통해 게시하여 처리
            NotificationCenter.default.post(name: .handleDeepLink, object: deepLinkURL)
        } else {
            print("No deep link found in notification")
        }

        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 파이어베이스에서 FCM 토큰을 수신할 때 호출
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")

        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        
        // TODO: 필요시 서버에 FCM 토큰 전송 로직 추가
    }
}
