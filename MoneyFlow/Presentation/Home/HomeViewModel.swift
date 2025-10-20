//
//  HomeViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import Combine

final class HomeViewModel: ObservableObject {
    @Published var totalBalance: Decimal = 0
    @Published var cards: [Card] = []
    @Published var isLoading = false
    
    private let cardRepository: CardRepositoryProtocol
    
    init(cardRepository: CardRepositoryProtocol = CardRepository()) {
        self.cardRepository = cardRepository
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        cards = cardRepository.getCards()
        totalBalance = cardRepository.getTotalBalance()
        
        isLoading = false
    }
}
