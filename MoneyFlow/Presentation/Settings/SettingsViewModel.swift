//
//  SettingsViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import Foundation
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var isBiometricEnabled = false
    @Published var selectedLanguage = "ru"
    @Published var showDeleteAlert = false
    
    private let biometricManager = BiometricManager.shared
    
    init() {
        loadSettings()
    }
    
    private func loadSettings() {
        isBiometricEnabled = UserDefaults.standard.bool(forKey: "biometricEnabled")
        selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "ru"
    }
    
    func enableBiometric() async {
        do {
            let success = try await biometricManager.authenticate(
                reason: "Включить \(biometricManager.biometricName)"
            )
            
            if success {
                await MainActor.run {
                    UserDefaults.standard.set(true, forKey: "biometricEnabled")
                    print("✅ \(biometricManager.biometricName) включен")
                }
            } else {
                await MainActor.run {
                    isBiometricEnabled = false
                }
            }
        } catch {
            await MainActor.run {
                isBiometricEnabled = false
                print("❌ Ошибка биометрии: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteAllData() {
        // TODO: Удалить все данные из CoreData
        HapticManager.success()
        print("🗑️ Все данные удалены")
    }
}
