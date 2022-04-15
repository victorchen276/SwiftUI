//
//  TaskApp.swift
//  Task
//
//  Created by Chen Yue on 14/04/22.
//

import SwiftUI

@main
struct TaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
