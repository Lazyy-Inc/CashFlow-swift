//
//  SubscriptionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/11/2024.
//

import Foundation
import Models

public extension SubscriptionModel {
    
    static let mockClassicSubscriptionExpense: SubscriptionModel = .init(
        id: 1,
        name: "Mock Subscription Expense",
        amount: 45,
        type: TransactionType.expense,
        frequency: SubscriptionFrequency.monthly,
        frequencyDate: Date(),
        category: .mock,
        subcategory: .mock
    )
    
}
