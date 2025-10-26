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
    private let transactionRepository: TransactionRepositoryProtocol
    private let cardRepository: CardRepositoryProtocol
    
    var isValid: Bool {
        guard let amount = Decimal(string: amountText), amount > 0 else {
            return false
        }
        return !merchantName.isEmpty && selectedCategory != nil
    }
    
    init(
        transactionRepository: TransactionRepositoryProtocol = TransactionRepository(),
        cardRepository: CardRepositoryProtocol = CardRepository()
    ) {
        self.transactionRepository = transactionRepository
        self.cardRepository = cardRepository
        selectedCategory = categories.first
    }
    
    func saveTransaction() {
        guard let amount = Decimal(string: amountText),
              let category = selectedCategory,
              let firstCard = cardRepository.getCards().first else {
            return
        }
        
        let transaction = Transaction(
            cardId: firstCard.id,
            amount: -amount,
            type: .expense,
            categoryId: category.id,
            merchantName: merchantName,
            note: note.isEmpty ? nil : note,
            date: date
        )
        
        transactionRepository.createTransaction(transaction)
        HapticManager.success()
        
        print("✅ Транзакция сохранена: \(Formatters.currency(amount)) в \(merchantName)")
    }
}
