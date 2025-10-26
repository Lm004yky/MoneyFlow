//
//  TransactionRow.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let category: Category?
    
    var body: some View {
        HStack(spacing: 12) {
            // Иконка категории
            if let category = category {
                Text(category.icon)
                    .font(.system(size: 32))
                    .frame(width: 50, height: 50)
                    .background(Color(hex: category.colorHex).opacity(0.2))
                    .cornerRadius(10)
            }
            
            // Информация
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.merchantName)
                    .font(.headline)
                    .foregroundColor(.theme.textPrimary)
                
                HStack(spacing: 4) {
                    if let category = category {
                        Text(category.name)
                            .font(.caption)
                            .foregroundColor(.theme.textSecondary)
                        
                        Text("•")
                            .foregroundColor(.theme.textSecondary)
                    }
                    
                    Text(Formatters.relativeDate(transaction.date))
                        .font(.caption)
                        .foregroundColor(.theme.textSecondary)
                }
            }
            
            Spacer()
            
            // Сумма
            Text(Formatters.currency(transaction.amount, currency: "₸"))
                .font(.headline)
                .foregroundColor(transaction.type == .expense ? .theme.danger : .theme.success)
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(Constants.Design.cornerRadius)
    }
}

#Preview {
    VStack {
        TransactionRow(
            transaction: Transaction(
                cardId: UUID(),
                amount: -5000,
                type: .expense,
                categoryId: UUID(),
                merchantName: "Magnum",
                date: Date()
            ),
            category: Category.defaultCategories[0]
        )
        
        TransactionRow(
            transaction: Transaction(
                cardId: UUID(),
                amount: 50000,
                type: .income,
                categoryId: UUID(),
                merchantName: "Зарплата",
                date: Date().addingTimeInterval(-86400)
            ),
            category: nil
        )
    }
    .padding()
}
