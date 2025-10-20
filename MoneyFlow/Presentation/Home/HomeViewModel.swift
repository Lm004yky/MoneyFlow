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
    @Published var isLoading = false
    
    private let coreDataManager = CoreDataManager.shared
    
    init() {
        loadData()
    }
    
    func loadData() {
        isLoading = true
        
        // TODO: Загрузка данных из CoreData
        // Пока заглушка
        totalBalance = 450000.50
        
        isLoading = false
    }
}
