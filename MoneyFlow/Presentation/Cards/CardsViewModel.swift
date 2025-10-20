//
//  CardsViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import Combine

final class CardsViewModel: ObservableObject {
    @Published var cards: [Card] = []
    @Published var isLoading = false
    
    private let cardRepository: CardRepositoryProtocol
    
    init(cardRepository: CardRepositoryProtocol = CardRepository()) {
        self.cardRepository = cardRepository
        loadCards()
    }
    
    func loadCards() {
        isLoading = true
        cards = cardRepository.getCards()
        isLoading = false
    }
}
