//
//  CardRepositoryProtocol.swift
//  MoneyFlow
//
//  Created by Ykylas Nurkhan on 20.10.2025.
//

import Foundation

protocol CardRepositoryProtocol {
    func getCards() -> [Card]
    func getCard(by id: UUID) -> Card?
    func createCard(_ card: Card)
    func updateCard(_ card: Card)
    func deleteCard(by id: UUID)
    func getTotalBalance() -> Decimal
}
