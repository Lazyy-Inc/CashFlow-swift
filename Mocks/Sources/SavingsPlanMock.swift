//
//  SavingsPlanMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation
import Models

public extension SavingsPlanModel {
    
    static let mockClassicSavingsPlan: SavingsPlanModel =  .init(
        id: 1,
        name: "Mock Savings Plan",
        emoji: "🤑",
        startDateString: Date().ISO8601Format(),
        currentAmount: 200,
        goalAmount: 2000
    )
    
}
