//
//  CardRowView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct CardRowView: View {
    let card: Card
    @State private var appeared = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: card.iconName)
                    .font(.title2)
                    .foregroundColor(.white)
                
                Spacer()
                
                Text(card.number)
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            
            Spacer()
            
            Text(card.name)
                .font(.headline)
                .foregroundColor(.white)
            
            Text(Formatters.currency(card.balance, currency: card.currency))
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
        }
        .padding(20)
        .frame(height: 200)
        .background(
            LinearGradient(
                colors: [Color(hex: card.colorHex), Color(hex: card.colorHex).opacity(0.7)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .cornerRadius(Constants.Design.cardCornerRadius)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .scaleEffect(appeared ? 1 : 0.9)
        .opacity(appeared ? 1 : 0)
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                appeared = true
            }
        }
    }
}

#Preview {
    CardRowView(
        card: Card(
            name: "Kaspi Gold",
            number: "4400",
            balance: 450000.50,
            colorHex: "#FFD700"
        )
    )
    .padding()
}
