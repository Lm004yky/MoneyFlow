//
//  StatisticsView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Период выбора
                    periodPicker
                    
                    // Общая статистика
                    summaryCard
                    
                    // График по категориям
                    categoryChart
                    
                    // Список категорий с процентами
                    categoryList
                }
                .padding()
            }
            .navigationTitle("tab.statistics".localized)
        }
        .onAppear {
            viewModel.loadData()
        }
    }
    
    private var periodPicker: some View {
        Picker("Период", selection: $viewModel.selectedPeriod) {
            Text("Неделя").tag(StatisticsPeriod.week)
            Text("Месяц").tag(StatisticsPeriod.month)
            Text("Год").tag(StatisticsPeriod.year)
        }
        .pickerStyle(.segmented)
    }
    
    private var summaryCard: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Расходы")
                        .font(.subheadline)
                        .foregroundColor(.theme.textSecondary)
                    
                    Text(Formatters.currency(viewModel.totalExpenses))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.theme.danger)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Доходы")
                        .font(.subheadline)
                        .foregroundColor(.theme.textSecondary)
                    
                    Text(Formatters.currency(viewModel.totalIncome))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.theme.success)
                }
            }
            
            Divider()
            
            HStack {
                Text("Баланс")
                    .font(.subheadline)
                    .foregroundColor(.theme.textSecondary)
                
                Spacer()
                
                Text(Formatters.currency(viewModel.balance))
                    .font(.headline)
                    .foregroundColor(viewModel.balance >= 0 ? .theme.success : .theme.danger)
            }
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(Constants.Design.cardCornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var categoryChart: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Расходы по категориям")
                .font(.headline)
                .foregroundColor(.theme.textPrimary)
            
            if viewModel.categoryData.isEmpty {
                Text("Нет данных")
                    .font(.subheadline)
                    .foregroundColor(.theme.textSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart {
                    ForEach(viewModel.categoryData) { data in
                        SectorMark(
                            angle: .value("Amount", data.amount),
                            innerRadius: .ratio(0.6),
                            angularInset: 2
                        )
                        .foregroundStyle(Color(hex: data.colorHex))
                        .annotation(position: .overlay) {
                            Text(data.icon)
                                .font(.title2)
                        }
                    }
                }
                .frame(height: 250)
            }
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(Constants.Design.cardCornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
    
    private var categoryList: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Детальная статистика")
                .font(.headline)
                .foregroundColor(.theme.textPrimary)
            
            ForEach(viewModel.categoryData) { data in
                HStack(spacing: 12) {
                    Text(data.icon)
                        .font(.title2)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(data.name)
                            .font(.subheadline)
                            .foregroundColor(.theme.textPrimary)
                        
                        Text("\(Int(data.percentage))%")
                            .font(.caption)
                            .foregroundColor(.theme.textSecondary)
                    }
                    
                    Spacer()
                    
                    Text(Formatters.currency(data.amount))
                        .font(.headline)
                        .foregroundColor(.theme.textPrimary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(Constants.Design.cardCornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    StatisticsView()
}
