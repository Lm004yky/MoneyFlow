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
    @Published var recentTransactions: [Transaction] = []
    @Published var isLoading = false
    
    private let cardRepository: CardRepositoryProtocol
    private let transactionRepository: TransactionRepositoryProtocol
    
    init(
        cardRepository: CardRepositoryProtocol = CardRepository(),
        transactionRepository: TransactionRepositoryProtocol = TransactionRepository()
    ) {
        self.cardRepository = cardRepository
        self.transactionRepository = transactionRepository
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        cards = cardRepository.getCards()
        totalBalance = cardRepository.getTotalBalance()
        recentTransactions = transactionRepository.getRecentTransactions(limit: 5)
        
        isLoading = false
    }
}
