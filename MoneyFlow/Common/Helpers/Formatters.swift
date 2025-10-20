//
//  Formatters.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

enum Formatters {
    
    // MARK: - Currency Formatter
    
    static func currency(_ amount: Decimal, currency: String = "₸") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        let formatted = formatter.string(from: amount as NSDecimalNumber) ?? "0"
        return "\(formatted) \(currency)"
    }
    
    // MARK: - Date Formatters
    
    static func date(_ date: Date, style: DateStyle = .medium) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        
        switch style {
        case .short:
            formatter.dateStyle = .short
        case .medium:
            formatter.dateStyle = .medium
        case .long:
            formatter.dateStyle = .long
        case .full:
            formatter.dateFormat = "d MMMM yyyy, HH:mm"
        }
        
        return formatter.string(from: date)
    }
    
    static func relativeDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = Locale.current
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    
    // MARK: - Number Formatter
    
    static func number(_ number: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
    
    enum DateStyle {
        case short
        case medium
        case long
        case full
    }
}
