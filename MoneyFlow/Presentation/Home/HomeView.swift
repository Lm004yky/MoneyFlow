//
//  HomeView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Баланс
                    balanceCard
                    
                    // Кнопка добавить расход
                    PrimaryButton(title: "Добавить расход") {
                        // TODO: Открыть экран добавления
                    }
                    .padding(.horizontal)
                }
                .padding(.top)
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
    
    private func formatBalance(_ amount: Decimal) -> String {
        Formatters.currency(amount)
    }
}

#Preview {
    HomeView()
}
