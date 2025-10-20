//
//  HapticManager.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import UIKit

enum HapticManager {
    
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    static func selection() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
    
    // Convenience methods
    static func success() {
        notification(.success)
    }
    
    static func error() {
        notification(.error)
    }
    
    static func warning() {
        notification(.warning)
    }
    
    static func light() {
        impact(.light)
    }
    
    static func medium() {
        impact(.medium)
    }
    
    static func heavy() {
        impact(.heavy)
    }
}
