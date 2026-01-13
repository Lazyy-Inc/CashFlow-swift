//
//  SubscriptionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUI

public struct SubscriptionModel: Identifiable, Equatable, Hashable, Sendable {
    public var id: Int
    public var name: String
    public var amount: Double
    public var type: FinancialItemType
    public var frequency: SubscriptionFrequency
    public var frequencyDate: Date
    public var category: CategoryModel?
    public var subcategory: SubcategoryModel?
    public var firstSubscriptionDate: Date?
    public var lastSubscriptionDate: Date?
    public var transactions: [TransactionModel]?

    // Initialiseur
    public init(
        id: Int,
        name: String,
        amount: Double,
        type: FinancialItemType,
        frequency: SubscriptionFrequency,
        frequencyDate: Date,
        category: CategoryModel?,
        subcategory: SubcategoryModel?,
        firstSubscriptionDate: Date? = nil,
        lastSubscriptionDate: Date? = nil,
        transactions: [TransactionModel]? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.frequency = frequency
        self.frequencyDate = frequencyDate
        self.category = category
        self.subcategory = subcategory
        self.firstSubscriptionDate = firstSubscriptionDate
        self.lastSubscriptionDate = lastSubscriptionDate
        self.transactions = transactions
    }
    
}

extension SubscriptionModel: FinancialItemProtocol {
    public var senderAccount: AccountModel? { return nil }
    public var receiverAccount: AccountModel? { return nil}
    
    public var date: Date {
        return frequencyDate
    }
}

extension SubscriptionModel: Searchable {
    public var searchableText: String {
        return name
    }
}

public extension SubscriptionModel {
    
    func toTransactionModel() -> TransactionModel {
        return TransactionModel(
            id: UUID().hashValue,
            name: self.name,
            amount: self.amount,
            date: self.frequencyDate,
            category: self.category,
            subcategory: self.subcategory,
            isFromSubscription: true,
            isFromApplePay: false
        )
    }
    
}

public extension SubscriptionModel {
    
    static let mockClassicSubscriptionExpense: SubscriptionModel = .init(
        id: 1,
        name: "Mock Subscription Expense",
        amount: 45,
        type: FinancialItemType.expense,
        frequency: SubscriptionFrequency.monthly,
        frequencyDate: Date(),
        category: .mock,
        subcategory: .mock
    )
    
}
