//
//  Cards.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

struct Card: Identifiable, Hashable {
    let id: UUID
    var name: String
    var number: String
    var balance: Decimal
    var currency: String
    var colorHex: String
    var iconName: String
    let createdAt: Date
    var updatedAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        number: String,
        balance: Decimal,
        currency: String = "₸",
        colorHex: String,
        iconName: String = "creditcard.fill",
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.number = number
        self.balance = balance
        self.currency = currency
        self.colorHex = colorHex
        self.iconName = iconName
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
