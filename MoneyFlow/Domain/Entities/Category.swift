//
//  Category.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

struct Category: Identifiable, Hashable {
    let id: UUID
    var name: String
    var icon: String // emoji
    var colorHex: String
    var isDefault: Bool
    let createdAt: Date
    
    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        colorHex: String,
        isDefault: Bool = false,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.isDefault = isDefault
        self.createdAt = createdAt
    }
    
    // Дефолтные категории
    static let defaultCategories: [Category] = [
        Category(name: "Еда", icon: "🍔", colorHex: "#FF9800", isDefault: true),
        Category(name: "Транспорт", icon: "🚗", colorHex: "#2196F3", isDefault: true),
        Category(name: "ЖКХ", icon: "🏠", colorHex: "#9C27B0", isDefault: true),
        Category(name: "Покупки", icon: "🛍", colorHex: "#E91E63", isDefault: true),
        Category(name: "Здоровье", icon: "💊", colorHex: "#4CAF50", isDefault: true),
        Category(name: "Развлечения", icon: "🎬", colorHex: "#F44336", isDefault: true),
        Category(name: "Другое", icon: "💰", colorHex: "#607D8B", isDefault: true)
    ]
}
