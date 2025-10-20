//
//  AddTransactionViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import Combine

final class AddTransactionViewModel: ObservableObject {
    @Published var amountText = ""
    @Published var merchantName = ""
    @Published var selectedCategory: Category?
    @Published var note = ""
    @Published var date = Date()
    
    let categories = Category.defaultCategories
    
    var isValid: Bool {
        guard let amount = Decimal(string: amountText), amount > 0 else {
            return false
        }
        return !merchantName.isEmpty && selectedCategory != nil
    }
    
    init() {
        selectedCategory = categories.first
    }
    
    func saveTransaction() {
        // TODO: Сохранить транзакцию в CoreData
        print("💾 Сохранение транзакции: \(amountText) ₸ в \(merchantName)")
    }
}
