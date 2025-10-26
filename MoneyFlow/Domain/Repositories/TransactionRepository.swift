//
//  TransactionRepository.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import CoreData

final class TransactionRepository: TransactionRepositoryProtocol {
    
    private let coreDataManager = CoreDataManager.shared
    
    func getTransactions() -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    }
    
    func getTransactions(for cardId: UUID) -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "cardId == %@", cardId as CVarArg)
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch transactions: \(error)")
            return []
        }
    }
    
    func getTransaction(by id: UUID) -> Transaction? {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.first.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch transaction: \(error)")
            return nil
        }
    }
    
    func createTransaction(_ transaction: Transaction) {
        let entity = TransactionEntity(context: coreDataManager.context)
        entity.id = transaction.id
        if let cardEntity = getCardEntity(by: transaction.cardId) {
            entity.card = cardEntity
        }
        entity.amount = NSDecimalNumber(decimal: transaction.amount)
        entity.type = transaction.type.rawValue
        entity.categoryId = transaction.categoryId
        entity.merchantName = transaction.merchantName
        entity.note = transaction.note
        entity.date = transaction.date
        entity.createdAt = transaction.createdAt
        
        coreDataManager.save()
    }
    
    private func getCardEntity(by id: UUID) -> CardEntity? {
        let request: NSFetchRequest<CardEntity> = CardEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? coreDataManager.context.fetch(request).first
    }
    
    func updateTransaction(_ transaction: Transaction) {
        guard let entity = getTransactionEntity(by: transaction.id) else { return }
        
        entity.amount = NSDecimalNumber(decimal: transaction.amount)
        entity.type = transaction.type.rawValue
        entity.categoryId = transaction.categoryId
        entity.merchantName = transaction.merchantName
        entity.note = transaction.note
        entity.date = transaction.date
        
        coreDataManager.save()
    }
    
    func deleteTransaction(by id: UUID) {
        guard let entity = getTransactionEntity(by: id) else { return }
        coreDataManager.context.delete(entity)
        coreDataManager.save()
    }
    
    func getRecentTransactions(limit: Int) -> [Transaction] {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        request.fetchLimit = limit
        
        do {
            let entities = try coreDataManager.context.fetch(request)
            return entities.map { mapToDomain($0) }
        } catch {
            print("Failed to fetch recent transactions: \(error)")
            return []
        }
    }
    
    // MARK: - Private
    
    private func getTransactionEntity(by id: UUID) -> TransactionEntity? {
        let request: NSFetchRequest<TransactionEntity> = TransactionEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        return try? coreDataManager.context.fetch(request).first
    }
    
    private func mapToDomain(_ entity: TransactionEntity) -> Transaction {
        Transaction(
            id: entity.id ?? UUID(),
            cardId: entity.card?.id ?? UUID(),
            amount: entity.amount?.decimalValue ?? 0,
            type: TransactionType(rawValue: entity.type ?? "expense") ?? .expense,
            categoryId: entity.categoryId ?? UUID(),
            merchantName: entity.merchantName ?? "",
            note: entity.note,
            date: entity.date ?? Date(),
            createdAt: entity.createdAt ?? Date()
        )
    }
}
