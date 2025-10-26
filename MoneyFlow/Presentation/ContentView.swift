//
//  ContentView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 19.10.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = AppRouter()
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("tab.home".localized, systemImage: "house.fill")
                }
            
            CardsView()
                .tabItem {
                    Label("tab.cards".localized, systemImage: "creditcard.fill")
                }
            
            StatisticsView()
                .tabItem {
                    Label("tab.statistics".localized, systemImage: "chart.bar.fill")
                }
            
            Text("tab.settings".localized)
                .tabItem {
                    Label("tab.settings".localized, systemImage: "gearshape.fill")
                }
        }
        .environmentObject(router)
        .sheet(item: $router.presentedSheet) { destination in
            sheetView(for: destination)
        }
        .fullScreenCover(item: $router.presentedFullScreen) { destination in
            fullScreenView(for: destination)
        }
    }
    
    @ViewBuilder
    private func sheetView(for destination: SheetDestination) -> some View {
        switch destination {
        case .addTransaction:
            AddTransactionView()
        case .editTransaction(let transaction):
            Text("Edit Transaction: \(transaction.merchantName)")
        case .addCard:
            AddCardView()
        case .editCard(let card):
            Text("Edit Card: \(card.name)")
        case .categoryPicker:
            Text("Category Picker") // TODO
        }
    }
    
    @ViewBuilder
    private func fullScreenView(for destination: FullScreenDestination) -> some View {
        switch destination {
        case .scanReceipt:
            Text("Scan Receipt") // TODO
        case .qrScanner:
            Text("QR Scanner") // TODO
        }
    }
}

#Preview {
    ContentView()
}
