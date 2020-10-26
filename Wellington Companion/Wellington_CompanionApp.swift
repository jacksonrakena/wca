//
//  Wellington_CompanionApp.swift
//  Wellington Companion
//
//  Created by Jackson Rakena on 26/Oct/20.
//

import SwiftUI

@main
struct Wellington_CompanionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
