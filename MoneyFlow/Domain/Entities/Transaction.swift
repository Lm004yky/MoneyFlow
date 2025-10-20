//
//  Transaction.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

struct Transaction: Identifiable, Hashable {
    let id: UUID
    let cardId: UUID
    var amount: Decimal
    var type: TransactionType
    var categoryId: UUID
    var merchantName: String
    var note: String?
    var date: Date
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        cardId: UUID,
        amount: Decimal,
        type: TransactionType,
        categoryId: UUID,
        merchantName: String,
        note: String? = nil,
        date: Date = Date(),
        createdAt: Date = Date()
    ) {
        self.id = id
        self.cardId = cardId
        self.amount = amount
        self.type = type
        self.categoryId = categoryId
        self.merchantName = merchantName
        self.note = note
        self.date = date
        self.createdAt = createdAt
    }
}

enum TransactionType: String {
    case income
    case expense
}
