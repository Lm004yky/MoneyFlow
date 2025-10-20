//
//  AddTransactionView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct AddTransactionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AddTransactionViewModel()
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Сумма") {
                    TextField("0", text: $viewModel.amountText)
                        .keyboardType(.decimalPad)
                        .font(.title)
                }
                
                Section("Детали") {
                    TextField("Название магазина", text: $viewModel.merchantName)
                    
                    Picker("Категория", selection: $viewModel.selectedCategory) {
                        ForEach(viewModel.categories) { category in
                            HStack {
                                Text(category.icon)
                                Text(category.name)
                            }
                            .tag(category as Category?)
                        }
                    }
                    
                    DatePicker("Дата", selection: $viewModel.date, displayedComponents: .date)
                    
                    TextField("Заметка (опционально)", text: $viewModel.note)
                }
            }
            .navigationTitle("Добавить расход")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Отмена") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Сохранить") {
                        viewModel.saveTransaction()
                        dismiss()
                    }
                    .disabled(!viewModel.isValid)
                }
            }
        }
    }
}

#Preview {
    AddTransactionView()
}
