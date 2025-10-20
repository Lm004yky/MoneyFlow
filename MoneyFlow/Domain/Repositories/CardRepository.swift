//
//  CardRepository.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import CoreData

final class CardRepository: CardRepositoryProtocol {
    
    private let coreDataManager = CoreDataManager.shared
    
    func getCards() -> [Card] {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: true)]
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch cards: \(error)")
            return []
        }
    }
    
    func getCard(by id: UUID) -> Card? {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.first.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch card: \(error)")
            return nil
        }
    }
    
    func createCard(_ card: Card) {
        let entity = CardEntity(context: coreDataManager.context)
        entity.id = card.id
        entity.name = card.name
        entity.number = card.number
        entity.balance = NSDecimalNumber(decimal: card.balance)
        entity.currency = card.currency
        entity.colorHex = card.colorHex
        entity.iconName = card.iconName
        entity.createdAt = card.createdAt
        entity.updatedAt = card.updatedAt
        
        coreDataManager.save()
    }
    
    func updateCard(_ card: Card) {
        guard let entity = getCardEntity(by: card.id) else { return }
        
        entity.name = card.name
        entity.number = card.number
        entity.balance = NSDecimalNumber(decimal: card.balance)
        entity.currency = card.currency
        entity.colorHex = card.colorHex
        entity.iconName = card.iconName
        entity.updatedAt = Date()
        
        coreDataManager.save()
    }
    
    func deleteCard(by id: UUID) {
        guard let entity = getCardEntity(by: id) else { return }
        coreDataManager.context.delete(entity)
        coreDataManager.save()
    }
    
    func getTotalBalance() -> Decimal {
        let cards = getCards()
        return cards.reduce(0) { $0 + $1.balance }
    }
    
    // MARK: - Private
    
    private func getCardEntity(by id: UUID) -> CardEntity? {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        return try? coreDataManager.context.fetch(request).first
    }
    
    private func mapToDomain(_ entity: CardEntity) -> Card {
        Card(
            id: entity.id ?? UUID(),
            name: entity.name ?? "",
            number: entity.number ?? "",
            balance: entity.balance?.decimalValue ?? 0,
            currency: entity.currency ?? "₸",
            colorHex: entity.colorHex ?? "#4CAF50",
            iconName: entity.iconName ?? "creditcard.fill",
            createdAt: entity.createdAt ?? Date(),
            updatedAt: entity.updatedAt ?? Date()
        )
    }
}
