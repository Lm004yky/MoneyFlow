//
//  AddCardViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import Foundation
import Combine

final class AddCardViewModel: ObservableObject {
    @Published var cardName = ""
    @Published var cardNumber = ""
    @Published var balanceText = ""
    @Published var currency = "₸"
    @Published var selectedColor = "#FFD700"
    
    let availableColors = [
        "#FFD700", // Золотой
        "#4CAF50", // Зеленый
        "#2196F3", // Синий
        "#9C27B0", // Фиолетовый
        "#FF5722", // Оранжевый
        "#607D8B"  // Серый
    ]
    
    private let cardRepository: CardRepositoryProtocol
    
    var isValid: Bool {
        !cardName.isEmpty &&
        cardNumber.count == 4 &&
        Decimal(string: balanceText) != nil
    }
    
    init(cardRepository: CardRepositoryProtocol = CardRepository()) {
        self.cardRepository = cardRepository
    }
    
    func saveCard() {
        guard isValid,
              let balance = Decimal(string: balanceText) else {
            return
        }
        
        let card = Card(
            name: cardName,
            number: cardNumber,
            balance: balance,
            currency: currency,
            colorHex: selectedColor
        )
        
        cardRepository.createCard(card)
        HapticManager.success()
        
        print("✅ Карта создана: \(cardName) с балансом \(Formatters.currency(balance, currency: currency))")
    }
}
