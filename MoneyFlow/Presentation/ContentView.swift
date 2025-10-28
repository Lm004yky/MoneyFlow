//
//  ContentView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 19.10.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var router = AppRouter()
    @State private var isUnlocked = false
    
    init() {
        // Проверяем включена ли биометрия
        let biometricEnabled = UserDefaults.standard.bool(forKey: "biometricEnabled")
        _isUnlocked = State(initialValue: !biometricEnabled)
    }

    var body: some View {
        ZStack {
            if isUnlocked || !BiometricManager.shared.isBiometricAvailable {
                // Показываем приложение только если разблокировано
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
                    
                    SettingsView()
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
                .transition(.opacity)
            } else {
                // Lock Screen
                LockScreenView(isUnlocked: $isUnlocked)
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: isUnlocked)
    }
    
    @ViewBuilder
    private func sheetView(for destination: SheetDestination) -> some View {
        switch destination {
        case .addTransaction:
            AddTransactionView()
                .environmentObject(router)
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
            ScanReceiptView()
                .environmentObject(router)
        case .qrScanner:
            Text("QR Scanner") // TODO
        }
    }
}

#Preview {
    ContentView()
}
