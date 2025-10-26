//
//  StatisticsViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import Foundation
import Combine

final class StatisticsViewModel: ObservableObject {
    @Published var selectedPeriod: StatisticsPeriod = .month {
        didSet {
            loadData()
        }
    }
    @Published var totalExpenses: Decimal = 0
    @Published var totalIncome: Decimal = 0
    @Published var categoryData: [CategoryStatistic] = []
    
    var balance: Decimal {
        totalIncome - totalExpenses
    }
    
    private let transactionRepository: TransactionRepositoryProtocol
    
    init(transactionRepository: TransactionRepositoryProtocol = TransactionRepository()) {
        self.transactionRepository = transactionRepository
    }
    
    func loadData() {
        let transactions = getTransactionsForPeriod()
        
        // Считаем расходы и доходы
        let expenses = transactions.filter { $0.type == .expense }
        let income = transactions.filter { $0.type == .income }
        
        totalExpenses = expenses.reduce(0) { $0 + abs($1.amount) }
        totalIncome = income.reduce(0) { $0 + $1.amount }
        
        // Группируем по категориям
        calculateCategoryStatistics(from: expenses)
    }
    
    private func getTransactionsForPeriod() -> [Transaction] {
        let calendar = Calendar.current
        let now = Date()
        let startDate: Date
        
        switch selectedPeriod {
        case .week:
            startDate = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        case .month:
            startDate = calendar.date(byAdding: .month, value: -1, to: now) ?? now
        case .year:
            startDate = calendar.date(byAdding: .year, value: -1, to: now) ?? now
        }
        
        return transactionRepository.getTransactions()
            .filter { $0.date >= startDate }
    }
    
    private func calculateCategoryStatistics(from transactions: [Transaction]) {
        // Группируем по категориям
        var categoryMap: [UUID: Decimal] = [:]
        
        for transaction in transactions {
            let amount = abs(transaction.amount)
            categoryMap[transaction.categoryId, default: 0] += amount
        }
        
        // Создаем статистику
        let total = categoryMap.values.reduce(0, +)
        
        categoryData = categoryMap.compactMap { categoryId, amount in
            guard let category = Category.defaultCategories.first(where: { $0.id == categoryId }) else {
                return nil
            }
            
            let percentage = total > 0 ? Double(truncating: (amount / total * 100) as NSDecimalNumber) : 0
            
            return CategoryStatistic(
                name: category.name,
                icon: category.icon,
                colorHex: category.colorHex,
                amount: amount,
                percentage: percentage
            )
        }
        .sorted { $0.amount > $1.amount } // Сортируем по убыванию
    }
}
