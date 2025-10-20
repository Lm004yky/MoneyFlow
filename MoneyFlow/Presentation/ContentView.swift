//
//  ContentView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 19.10.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("tab.home".localized, systemImage: "house.fill")
                }
            
            Text("tab.cards".localized)
                .tabItem {
                    Label("tab.cards".localized, systemImage: "creditcard.fill")
                }
            
            Text("tab.statistics".localized)
                .tabItem {
                    Label("tab.statistics".localized, systemImage: "chart.bar.fill")
                }
            
            Text("tab.settings".localized)
                .tabItem {
                    Label("tab.settings".localized, systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
