//
//  LinerApp.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI
import FirebaseCore


@main
struct LinerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            UserInfoCreateTest()
        }
    }
}
