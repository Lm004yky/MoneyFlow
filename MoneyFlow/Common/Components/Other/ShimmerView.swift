//
//  ShimmerView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct ShimmerView: View {
    @State private var phase: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.gray.opacity(0.2)
                
                LinearGradient(
                    colors: [
                        .clear,
                        .white.opacity(0.5),
                        .clear
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase * geometry.size.width)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
    }
}

// View modifier для удобства
extension View {
    func shimmer() -> some View {
        self.overlay(ShimmerView())
            .mask(self)
    }
}

#Preview {
    VStack(spacing: 16) {
        RoundedRectangle(cornerRadius: 12)
            .frame(height: 200)
            .shimmer()
        
        RoundedRectangle(cornerRadius: 8)
            .frame(height: 50)
            .shimmer()
    }
    .padding()
}
