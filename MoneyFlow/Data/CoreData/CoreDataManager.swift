//
//  CoreDataManager.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import CoreData
import Foundation

final class CoreDataManager {
    static let shared = CoreDataManager()
    
    private init() {}
    
    // MARK: - Core Data Stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MoneyFlow")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("CoreData failed to load: \(error.localizedDescription)")
            }
        }
        
        container.viewContext.automaticallyMergesChangesFromParent = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
        return container
    }()
    
    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    // MARK: - Save
    
    func save() {
        let context = persistentContainer.viewContext
        
        guard context.hasChanges else { return }
        
        do {
            try context.save()
        } catch {
            print("Failed to save CoreData: \(error)")
        }
    }
    
    // MARK: - Initial Data

    func populateInitialDataIfNeeded() {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        
        do {
            let count = try context.count(for: request)
            if count == 0 {
                createSampleData()
            }
        } catch {
            print("Error checking data: \(error)")
        }
    }

    private func createSampleData() {
        // Создать пример карты
        let card = CardEntity(context: context)
        card.id = UUID()
        card.name = "Kaspi Gold"
        card.number = "4400"
        card.balance = NSDecimalNumber(decimal: 450000.50)
        card.currency = "₸"
        card.colorHex = "#FFD700"
        card.iconName = "creditcard.fill"
        card.createdAt = Date()
        card.updatedAt = Date()
        
        save()
        print("✅ Sample data created")
    }
}
