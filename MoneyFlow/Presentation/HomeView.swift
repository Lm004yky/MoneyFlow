//
//  HomeView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Главный экран")
                        .font(.largeTitle)
                }
                .padding()
            }
            .navigationTitle("tab.home".localized)
        }
    }
}

#Preview {
    HomeView()
}
