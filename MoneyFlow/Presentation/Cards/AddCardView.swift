//
//  AddCardView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI

struct AddCardView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddCardViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Информация о карте") {
                    TextField("Название карты", text: $viewModel.cardName)
                        .autocorrectionDisabled()
                    
                    TextField("card.lastDigits".localized, text: $viewModel.cardNumber)
                        .keyboardType(.numberPad)
                        .onChange(of: viewModel.cardNumber) { newValue in
                            if newValue.count > 4 {
                                viewModel.cardNumber = String(newValue.prefix(4))
                            }
                        }
                    
                    TextField("Начальный баланс", text: $viewModel.balanceText)
                        .keyboardType(.decimalPad)
                    
                    Picker("Валюта", selection: $viewModel.currency) {
                        Text("₸ Тенге").tag("₸")
                        Text("$ Доллар").tag("$")
                        Text("€ Евро").tag("€")
                        Text("₽ Рубль").tag("₽")
                    }
                }
                
                Section("Оформление") {
                    Picker("Цвет карты", selection: $viewModel.selectedColor) {
                        ForEach(viewModel.availableColors, id: \.self) { color in
                            HStack {
                                Circle()
                                    .fill(Color(hex: color))
                                    .frame(width: 24, height: 24)
                                Text(colorName(for: color))
                            }
                            .tag(color)
                        }
                    }
                }
                
                Section {
                    // Preview карты
                    cardPreview
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                }
            }
            .navigationTitle("Новая карта")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Создать") {
                        viewModel.saveCard()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
    
    private var cardPreview: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "creditcard.fill")
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(viewModel.cardNumber.isEmpty ? "****" : viewModel.cardNumber)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Text(viewModel.cardName.isEmpty ? "Моя карта" : viewModel.cardName)
                .font(.headline)
                .foregroundColor(.white)
            
            if let balance = Decimal(string: viewModel.balanceText) {
                Text(Formatters.currency(balance, currency: viewModel.currency))
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .padding(20)
        .frame(height: 200)
        .background(
            LinearGradient(
                colors: [
                    Color(hex: viewModel.selectedColor),
                    Color(hex: viewModel.selectedColor).opacity(0.7)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Constants.Design.cardCornerRadius)
        .padding()
    }
    
    private func colorName(for hex: String) -> String {
        switch hex {
        case "#FFD700": return "Золотой"
        case "#4CAF50": return "Зеленый"
        case "#2196F3": return "Синий"
        case "#9C27B0": return "Фиолетовый"
        case "#FF5722": return "Оранжевый"
        case "#607D8B": return "Серый"
        default: return "Цвет"
        }
    }
}

#Preview {
    AddCardView()
}
