//
//  TransactionRepositoryProtocol.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

protocol TransactionRepositoryProtocol {
    func getTransactions() -> [Transaction]
    func getTransactions(for cardId: UUID) -> [Transaction]
    func getTransaction(by id: UUID) -> Transaction?
    func createTransaction(_ transaction: Transaction)
    func updateTransaction(_ transaction: Transaction)
    func deleteTransaction(by id: UUID)
    func getRecentTransactions(limit: Int) -> [Transaction]
}
