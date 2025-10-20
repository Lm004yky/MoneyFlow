//
//  MoneyFlowApp.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 19.10.2025.
//

import SwiftUI

@main
struct MoneyFlowApp: App {
    
    let coreDataManager = CoreDataManager.shared
    
    init() {
        coreDataManager.populateInitialDataIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.context)
        }
    }
}
