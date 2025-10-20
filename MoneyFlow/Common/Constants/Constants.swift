//
//  Constants.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation
import SwiftUI

enum Constants {
    
    enum App {
        static let name = "MoneyFlow"
        static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }
    
    enum Design {
        static let cornerRadius: CGFloat = 12
        static let cardCornerRadius: CGFloat = 16
        static let padding: CGFloat = 16
        static let smallPadding: CGFloat = 8
    }
    
    enum Animation {
        static let standard: Double = 0.3
        static let quick: Double = 0.2
    }
}
