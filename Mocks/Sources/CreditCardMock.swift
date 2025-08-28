//
//  File.swift
//  Mocks
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models

public extension CreditCardModel {
  
  static let mock: CreditCardModel = .init(
    uuid: UUID(),
    holder: "Test Holder",
    number: "1234 5678 9012 3456",
    cvc: "123",
    expirateDate: Date().ISO8601Format(),
    limitByMonth: 1500
  )
  
}
