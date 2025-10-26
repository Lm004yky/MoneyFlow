//
//  BiometricManager.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import LocalAuthentication
import Foundation

final class BiometricManager {
    static let shared = BiometricManager()
    
    private init() {}
    
    // MARK: - Biometric Type
    
    enum BiometricType {
        case faceID
        case touchID
        case none
    }
    
    var biometricType: BiometricType {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return .none
        }
        
        switch context.biometryType {
        case .faceID:
            return .faceID
        case .touchID:
            return .touchID
        default:
            return .none
        }
    }
    
    var isBiometricAvailable: Bool {
        biometricType != .none
    }
    
    var biometricName: String {
        switch biometricType {
        case .faceID:
            return "Face ID"
        case .touchID:
            return "Touch ID"
        case .none:
            return "Биометрия"
        }
    }
    
    // MARK: - Authentication
    
    func authenticate(reason: String = "Войти в приложение") async throws -> Bool {
        let context = LAContext()
        var error: NSError?
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            throw BiometricError.notAvailable
        }
        
        do {
            let success = try await context.evaluatePolicy(
                .deviceOwnerAuthenticationWithBiometrics,
                localizedReason: reason
            )
            
            if success {
                HapticManager.success()
            }
            
            return success
        } catch {
            throw BiometricError.authenticationFailed
        }
    }
}

// MARK: - Errors

enum BiometricError: LocalizedError {
    case notAvailable
    case authenticationFailed
    
    var errorDescription: String? {
        switch self {
        case .notAvailable:
            return "Биометрическая аутентификация недоступна"
        case .authenticationFailed:
            return "Не удалось пройти аутентификацию"
        }
    }
}
