//
//  CardsView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct CardsView: View {
    @StateObject private var viewModel = CardsViewModel()
    @EnvironmentObject var router: AppRouter
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.cards.isEmpty {
                        emptyState
                    } else {
                        cardsCarousel
                    }
                }
                .padding()
            }
            .navigationTitle("tab.cards".localized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        router.presentSheet(.addCard)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                viewModel.loadCards()
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "creditcard.fill")
                .font(.system(size: 60))
                .foregroundColor(.theme.textSecondary)
            
            Text("Нет карт")
                .font(.title2)
                .foregroundColor(.theme.textPrimary)
            
            Text("Добавьте первую карту")
                .font(.subheadline)
                .foregroundColor(.theme.textSecondary)
            
            PrimaryButton(title: "Добавить карту") {
                // TODO: Добавить карту
            }
            .padding(.top)
        }
        .padding(.top, 100)
    }
    
    private var cardsCarousel: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.cards) { card in
                CardRowView(card: card)
            }
        }
    }
}

#Preview {
    CardsView()
}
