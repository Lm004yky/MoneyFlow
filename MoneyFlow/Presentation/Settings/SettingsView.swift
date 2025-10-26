//
//  SettingsView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            List {
                // Безопасность
                Section("Безопасность") {
                    if BiometricManager.shared.isBiometricAvailable {
                        Toggle(isOn: $viewModel.isBiometricEnabled) {
                            HStack {
                                Image(systemName: biometricIcon)
                                    .foregroundColor(.theme.primary)
                                Text(BiometricManager.shared.biometricName)
                            }
                        }
                        .onChange(of: viewModel.isBiometricEnabled) { newValue in
                            if newValue {
                                Task {
                                    await viewModel.enableBiometric()
                                }
                            }
                        }
                    }
                }
                
                // Внешний вид
                Section("Внешний вид") {
                    Toggle(isOn: $isDarkMode) {
                        HStack {
                            Image(systemName: "moon.fill")
                                .foregroundColor(.theme.primary)
                            Text("Темная тема")
                        }
                    }
                }
                
                // Язык
                Section("Язык") {
                    Picker("Язык приложения", selection: $viewModel.selectedLanguage) {
                        Text("English").tag("en")
                        Text("Русский").tag("ru")
                        Text("Қазақша").tag("kk")
                    }
                }
                
                // О приложении
                Section("О приложении") {
                    HStack {
                        Text("Версия")
                        Spacer()
                        Text(Constants.App.version)
                            .foregroundColor(.theme.textSecondary)
                    }
                    
                    HStack {
                        Text("Разработчик")
                        Spacer()
                        Text("Ykylas Nurkhan")
                            .foregroundColor(.theme.textSecondary)
                    }
                }
                
                // Данные
                Section("Данные") {
                    Button(role: .destructive) {
                        viewModel.showDeleteAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "trash")
                            Text("Удалить все данные")
                        }
                    }
                }
            }
            .navigationTitle("tab.settings".localized)
            .alert("Удалить все данные?", isPresented: $viewModel.showDeleteAlert) {
                Button("Отмена", role: .cancel) { }
                Button("Удалить", role: .destructive) {
                    viewModel.deleteAllData()
                }
            } message: {
                Text("Это действие нельзя отменить")
            }
        }
    }
    
    private var biometricIcon: String {
        switch BiometricManager.shared.biometricType {
        case .faceID:
            return "faceid"
        case .touchID:
            return "touchid"
        case .none:
            return "lock.fill"
        }
    }
}

#Preview {
    SettingsView()
}
