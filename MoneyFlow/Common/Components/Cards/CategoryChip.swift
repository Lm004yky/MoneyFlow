//
//  CategoryChip.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct CategoryChip: View {
    let category: Category
    
    var body: some View {
        VStack(spacing: 8) {
            Text(category.icon)
                .font(.system(size: 32))
            
            Text(category.name)
                .font(.caption)
                .foregroundColor(.theme.textPrimary)
        }
        .frame(width: 80, height: 80)
        .background(Color(hex: category.colorHex).opacity(0.1))
        .cornerRadius(Constants.Design.cornerRadius)
    }
}

#Preview {
    HStack {
        CategoryChip(category: Category.defaultCategories[0])
        CategoryChip(category: Category.defaultCategories[1])
        CategoryChip(category: Category.defaultCategories[2])
    }
    .padding()
}
