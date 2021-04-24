//
//  RelaxTimerApp.swift
//  Shared
//
//  Created by Viktor Kushnerov on 24.04.21.
//

import SwiftUI

@main
struct RelaxTimerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            CloudKitView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
            ContentView()
        }
    }
}
