//
//  LockScreenView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI

struct LockScreenView: View {
    @Binding var isUnlocked: Bool
    @State private var isAuthenticating = false
    @State private var showError = false
    @State private var errorMessage = ""
    
    var body: some View {
        ZStack {
            // Градиентный фон
            LinearGradient(
                colors: [Color.theme.primary, Color.theme.primary.opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // Иконка
                Image(systemName: biometricIcon)
                    .font(.system(size: 80))
                    .foregroundColor(.white)
                
                // Текст
                VStack(spacing: 12) {
                    Text(Constants.App.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Text("Используйте \(BiometricManager.shared.biometricName) для входа")
                        .font(.subheadline)
                        .foregroundColor(.white.opacity(0.8))
                        .multilineTextAlignment(.center)
                }
                
                Spacer()
                
                // Кнопка разблокировки
                Button(action: {
                    authenticate()
                }) {
                    HStack {
                        Image(systemName: biometricIcon)
                        Text("Разблокировать")
                    }
                    .font(.headline)
                    .foregroundColor(.theme.primary)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(Color.white)
                    .cornerRadius(Constants.Design.cornerRadius)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 40)
                .disabled(isAuthenticating)
            }
        }
        .alert("Ошибка", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .onAppear {
            // Автоматическая аутентификация при появлении
            authenticate()
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
    
    private func authenticate() {
        guard !isAuthenticating else { return }
        isAuthenticating = true
        
        Task {
            do {
                let success = try await BiometricManager.shared.authenticate()
                
                await MainActor.run {
                    if success {
                        withAnimation {
                            isUnlocked = true
                        }
                    }
                    isAuthenticating = false
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    showError = true
                    isAuthenticating = false
                }
            }
        }
    }
}

#Preview {
    LockScreenView(isUnlocked: .constant(false))
}
