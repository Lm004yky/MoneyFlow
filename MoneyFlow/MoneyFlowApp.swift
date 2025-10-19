//
//  MoneyFlowApp.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 19.10.2025.
//

import SwiftUI
import CoreData

@main
struct MoneyFlowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
