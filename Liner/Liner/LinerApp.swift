//
//  LinerApp.swift
//  Liner
//
//  Created by KimYuBin on 8/23/24.
//

import SwiftUI

@main
struct FCNTestApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            NavigationStack{
                ContentView()
            }
        }
    }
}
