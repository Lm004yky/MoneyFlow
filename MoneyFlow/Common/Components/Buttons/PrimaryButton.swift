//
//  PrimaryButton.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 50)
                .background(Color.theme.primary)
                .cornerRadius(Constants.Design.cornerRadius)
        }
    }
}

#Preview {
    VStack {
        PrimaryButton(title: "Добавить расход") { }
        PrimaryButton(title: "Сохранить") { }
    }
    .padding()
}
