//
//  AppRouter.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI
import Combine

final class AppRouter: ObservableObject {
    
    // MARK: - Navigation State
    
    @Published var homeNavigationPath = NavigationPath()
    @Published var presentedSheet: SheetDestination?
    @Published var presentedFullScreen: FullScreenDestination?
    
    // MARK: - Navigation Methods
    
    func presentSheet(_ destination: SheetDestination) {
        presentedSheet = destination
    }
    
    func dismissSheet() {
        presentedSheet = nil
    }
    
    func presentFullScreen(_ destination: FullScreenDestination) {
        presentedFullScreen = destination
    }
    
    func dismissFullScreen() {
        presentedFullScreen = nil
    }
}

// MARK: - Destinations

enum SheetDestination: Identifiable {
    case addTransaction
    case editTransaction(Transaction)
    case addCard
    case editCard(Card)
    case categoryPicker
    
    var id: String {
        switch self {
        case .addTransaction:
            return "addTransaction"
        case .editTransaction(let transaction):
            return "editTransaction-\(transaction.id)"
        case .addCard:
            return "addCard"
        case .editCard(let card):
            return "editCard-\(card.id)"
        case .categoryPicker:
            return "categoryPicker"
        }
    }
}

enum FullScreenDestination: Identifiable {
    case scanReceipt
    case qrScanner
    
    var id: String {
        switch self {
        case .scanReceipt:
            return "scanReceipt"
        case .qrScanner:
            return "qrScanner"
        }
    }
}
