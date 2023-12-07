//
//  Expense_TrackerApp.swift
//  Expense Tracker
//
//  Created by Justin Sohn on 12/5/23.
//  CWID: 885830877

import SwiftUI

@main
struct Expense_TrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        // Container
        .modelContainer(for: [Expense.self, Category.self])
    }
}
