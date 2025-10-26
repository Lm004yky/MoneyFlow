//
//  StatisticsModels.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import Foundation

enum StatisticsPeriod {
    case week
    case month
    case year
}

struct CategoryStatistic: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let colorHex: String
    let amount: Decimal
    let percentage: Double
}
