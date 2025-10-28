//
//  VisionService.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 26.10.2025.
//

import Vision
import UIKit

final class VisionService {
    static let shared = VisionService()
    
    private init() {}
    
    // MARK: - Text Recognition
    
    func recognizeText(from image: UIImage) async throws -> String {
        guard let cgImage = image.cgImage else {
            throw VisionError.invalidImage
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            let request = VNRecognizeTextRequest { request, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                guard let observations = request.results as? [VNRecognizedTextObservation] else {
                    continuation.resume(throwing: VisionError.noTextFound)
                    return
                }
                
                let recognizedText = observations.compactMap { observation in
                    observation.topCandidates(1).first?.string
                }.joined(separator: "\n")
                
                continuation.resume(returning: recognizedText)
            }
            
            request.recognitionLevel = .accurate
            request.recognitionLanguages = ["ru-RU", "en-US", "kk-KZ"]
            request.usesLanguageCorrection = true
            
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            do {
                try handler.perform([request])
            } catch {
                continuation.resume(throwing: error)
            }
        }
    }
    
    // MARK: - Parse Receipt Data
    
    func parseReceipt(from text: String) -> (amount: Decimal?, merchantName: String?) {
        var amount: Decimal?
        var merchantName: String?
        
        let lines = text.components(separatedBy: .newlines)
        
        // Ищем TOTAL или ИТОГ или Subtotal
        for (index, line) in lines.enumerated() {
            let cleanLine = line.trimmingCharacters(in: .whitespaces).uppercased()
            
            if cleanLine.contains("TOTAL") || cleanLine.contains("ИТОГ") ||
               cleanLine.contains("SUBTOTAL") || cleanLine.contains("К ОПЛАТЕ") {
                
                // Ищем число в этой строке или следующей
                let searchLines = [line] + (index + 1 < lines.count ? [lines[index + 1]] : [])
                
                for searchLine in searchLines {
                    // Ищем все числа с точкой или запятой
                    let pattern = #"(\d+[\.,]\d+)"#
                    if let regex = try? NSRegularExpression(pattern: pattern) {
                        let matches = regex.matches(in: searchLine, range: NSRange(searchLine.startIndex..., in: searchLine))
                        
                        for match in matches {
                            if let range = Range(match.range, in: searchLine) {
                                let numberStr = String(searchLine[range]).replacingOccurrences(of: ",", with: ".")
                                if let num = Decimal(string: numberStr), num >= 1 {
                                    amount = num
                                    break
                                }
                            }
                        }
                    }
                    if amount != nil { break }
                }
                
                if amount != nil { break }
            }
        }
        
        // Магазин - первая непустая строка длиной 3-50 символов
        for line in lines.prefix(10) {
            let clean = line.trimmingCharacters(in: .whitespaces)
            if clean.count >= 3 && clean.count <= 50 && !clean.contains("RECEIPT") && !clean.contains("ЧЕК") {
                merchantName = clean
                break
            }
        }
        
        return (amount, merchantName)
    }
    
    private func extractAmount(from text: String) -> Decimal? {
        // Паттерн для чисел с разделителем и без
        let patterns = [
            #"(\d+\s*[\.,]\s*\d{2})"#,  // 920.00 или 920,00 или 920 . 00
            #"(\d+)"#                     // просто число 920
        ]
        
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern),
               let match = regex.firstMatch(in: text, range: NSRange(text.startIndex..., in: text)),
               let range = Range(match.range, in: text) {
                let amountString = String(text[range])
                    .replacingOccurrences(of: ",", with: ".")
                    .replacingOccurrences(of: " ", with: "")
                
                if let amount = Decimal(string: amountString) {
                    // Проверяем что это разумная сумма
                    if amount >= 1 && amount <= 1000000 {
                        return amount
                    }
                }
            }
        }
        
        return nil
    }
}

// MARK: - Errors

enum VisionError: LocalizedError {
    case invalidImage
    case noTextFound
    
    var errorDescription: String? {
        switch self {
        case .invalidImage:
            return "Неверное изображение"
        case .noTextFound:
            return "Текст не найден на изображении"
        }
    }
}
