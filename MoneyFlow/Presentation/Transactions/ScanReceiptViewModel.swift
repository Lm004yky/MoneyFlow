//
//  ScanReceiptViewModel.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import SwiftUI
import PhotosUI
import Combine

final class ScanReceiptViewModel: ObservableObject {
    @Published var selectedPhoto: PhotosPickerItem?
    @Published var showImagePicker = false
    @Published var isProcessing = false
    @Published var recognizedText = ""
    @Published var parsedAmount: Decimal?
    @Published var parsedMerchant: String?
    @Published var showError = false
    @Published var errorMessage = ""
    
    private let visionService = VisionService.shared
    private let transactionRepository: TransactionRepositoryProtocol
    private let cardRepository: CardRepositoryProtocol
    
    init(
        transactionRepository: TransactionRepositoryProtocol = TransactionRepository(),
        cardRepository: CardRepositoryProtocol = CardRepository()
    ) {
        self.transactionRepository = transactionRepository
        self.cardRepository = cardRepository
    }
    
    @MainActor
    func processSelectedImage() async {
        guard let selectedPhoto = selectedPhoto else { return }
        
        isProcessing = true
        
        do {
            // Загружаем изображение
            guard let imageData = try await selectedPhoto.loadTransferable(type: Data.self),
                  let image = UIImage(data: imageData) else {
                throw VisionError.invalidImage
            }
            
            // Распознаем текст
            recognizedText = try await visionService.recognizeText(from: image)
            
            // Парсим данные чека
            let result = visionService.parseReceipt(from: recognizedText)
            parsedAmount = result.amount
            parsedMerchant = result.merchantName
            
            HapticManager.success()
            
            print("✅ Распознано:")
            print("Текст: \(recognizedText)")
            print("Сумма: \(parsedAmount?.description ?? "не найдена")")
            print("Магазин: \(parsedMerchant ?? "не найден")")
            
        } catch {
            errorMessage = error.localizedDescription
            showError = true
            HapticManager.error()
        }
        
        isProcessing = false
    }
    
    func createTransaction() {
        guard let amount = parsedAmount,
              let merchant = parsedMerchant,
              let firstCard = cardRepository.getCards().first else {
            return
        }
        
        let transaction = Transaction(
            cardId: firstCard.id,
            amount: -amount,
            type: .expense,
            categoryId: Category.defaultCategories[0].id,
            merchantName: merchant,
            date: Date()
        )
        
        transactionRepository.createTransaction(transaction)
        HapticManager.success()
        
        // Уведомляем об обновлении
        NotificationCenter.default.post(name: NSNotification.Name("TransactionCreated"), object: nil)
        
        print("✅ Транзакция создана из чека")
    }
    
    func reset() {
        selectedPhoto = nil
        recognizedText = ""
        parsedAmount = nil
        parsedMerchant = nil
    }
}
