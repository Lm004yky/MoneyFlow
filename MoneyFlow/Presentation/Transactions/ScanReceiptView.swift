//
//  ScanReceiptView.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI
import PhotosUI

struct ScanReceiptView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ScanReceiptViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                if viewModel.isProcessing {
                    processingView
                } else if viewModel.recognizedText.isEmpty {
                    instructionsView
                } else {
                    resultView
                }
            }
            .navigationTitle("Сканировать чек")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
            }
            .photosPicker(
                isPresented: $viewModel.showImagePicker,
                selection: $viewModel.selectedPhoto,
                matching: .images
            )
            .onChange(of: viewModel.selectedPhoto) { newValue in
                Task {
                    await viewModel.processSelectedImage()
                }
            }
            .alert("Ошибка", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
    
    private var instructionsView: some View {
        VStack(spacing: 32) {
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.theme.primary)
            
            VStack(spacing: 12) {
                Text("Отсканируйте чек")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Выберите фото чека из галереи")
                    .font(.subheadline)
                    .foregroundColor(.theme.textSecondary)
                    .multilineTextAlignment(.center)
            }
            
            VStack(spacing: 16) {
                PrimaryButton(title: "Выбрать из галереи") {
                    viewModel.showImagePicker = true
                }
                
                Button("Сделать фото") {
                    // TODO: Открыть камеру
                }
                .font(.headline)
                .foregroundColor(.theme.primary)
            }
            .padding(.horizontal, 40)
        }
    }
    
    private var processingView: some View {
        VStack(spacing: 24) {
            ProgressView()
                .scaleEffect(1.5)
            
            Text("Распознаю текст...")
                .font(.headline)
                .foregroundColor(.theme.textSecondary)
        }
    }
    
    private var resultView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Найденные данные
                if let amount = viewModel.parsedAmount {
                    dataCard(
                        title: "Сумма",
                        value: Formatters.currency(amount),
                        icon: "dollarsign.circle.fill",
                        color: .theme.success
                    )
                }
                
                if let merchant = viewModel.parsedMerchant {
                    dataCard(
                        title: "Магазин",
                        value: merchant,
                        icon: "storefront.fill",
                        color: .theme.primary
                    )
                }
                
                // Распознанный текст
                VStack(alignment: .leading, spacing: 8) {
                    Text("Распознанный текст:")
                        .font(.headline)
                        .foregroundColor(.theme.textPrimary)
                    
                    Text(viewModel.recognizedText)
                        .font(.caption)
                        .foregroundColor(.theme.textSecondary)
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(Constants.Design.cornerRadius)
                }
                
                // Кнопки
                VStack(spacing: 12) {
                    PrimaryButton(title: "Создать транзакцию") {
                        viewModel.createTransaction()
                        dismiss()
                    }
                    .disabled(viewModel.parsedAmount == nil)
                    
                    Button("Попробовать снова") {
                        viewModel.reset()
                    }
                    .font(.headline)
                    .foregroundColor(.theme.primary)
                }
            }
            .padding()
        }
    }
    
    private func dataCard(title: String, value: String, icon: String, color: Color) -> some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title)
                .foregroundColor(color)
                .frame(width: 50, height: 50)
                .background(color.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.theme.textSecondary)
                
                Text(value)
                    .font(.headline)
                    .foregroundColor(.theme.textPrimary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color.theme.background)
        .cornerRadius(Constants.Design.cornerRadius)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    ScanReceiptView()
}
