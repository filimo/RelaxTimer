//
//  RelaxTimerApp.swift
//  RelaxTimer WatchKit Extension
//
//  Created by Viktor Kushnerov on 3.05.21.
//

import SwiftUI

@main
struct RelaxTimerApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
