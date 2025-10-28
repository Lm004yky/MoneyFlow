//
//  HomeView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Баланс
                    balanceCard
                    
                    // Категории
                    categoriesSection
                    
                    // Последние транзакции
                    if !viewModel.recentTransactions.isEmpty {
                        recentTransactionsSection
                    }
                    
                    // Кнопка добавить расход
                    HStack(spacing: 12) {
                        // Кнопка добавить расход
                        PrimaryButton(title: "Добавить расход") {
                            router.presentSheet(.addTransaction)
                        }
                        
                        // Кнопка сканировать чек
                        Button {
                            router.presentFullScreen(.scanReceipt)
                        } label: {
                            Image(systemName: "doc.text.viewfinder")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 50, height: 50)
                                .background(Color.theme.primary)
                                .cornerRadius(Constants.Design.cornerRadius)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
            }
            .refreshable {
                await refreshData()
            }
            .navigationTitle("tab.home".localized)
        }
    }
    
    private var balanceCard: some View {
        VStack(spacing: 8) {
            Text("Общий баланс")
                .font(.subheadline)
                .foregroundColor(.theme.textSecondary)
            
            Text(formatBalance(viewModel.totalBalance))
                .font(.system(size: 36, weight: .bold))
                .foregroundColor(.theme.textPrimary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 32)
        .background(Color.theme.primary.opacity(0.1))
        .cornerRadius(Constants.Design.cardCornerRadius)
        .padding(.horizontal)
    }
    
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Категории")
                .font(.headline)
                .foregroundColor(.theme.textPrimary)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Category.defaultCategories) { category in
                        CategoryChip(category: category)
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func formatBalance(_ amount: Decimal) -> String {
        Formatters.currency(amount)
    }
    
    private func refreshData() async {
        HapticManager.light()
        try? await Task.sleep(seconds: 0.5)
        viewModel.loadData()
    }
    
    private var recentTransactionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Последние операции")
                .font(.headline)
                .foregroundColor(.theme.textPrimary)
                .padding(.horizontal)
            
            VStack(spacing: 8) {
                ForEach(viewModel.recentTransactions) { transaction in
                    SwipeableView(
                        content: {
                            TransactionRow(
                                transaction: transaction,
                                category: findCategory(for: transaction.categoryId)
                            )
                        },
                        onDelete: {
                            deleteTransaction(transaction)
                        }
                    )
                }
            }
            .padding(.horizontal)
        }
    }

    private func findCategory(for id: UUID) -> Category? {
        Category.defaultCategories.first { $0.id == id }
    }
    
    private func deleteTransaction(_ transaction: Transaction) {
        HapticManager.medium()
        viewModel.deleteTransaction(transaction)
    }
}

#Preview {
    HomeView()
}
