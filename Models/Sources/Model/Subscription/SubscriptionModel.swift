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
    public var type: TransactionType
    public var frequency: SubscriptionFrequency
    public var frequencyDate: Date
    public var categoryID: Int
    public var subcategoryID: Int?
    public var firstSubscriptionDate: Date?
    public var lastSubscriptionDate: Date?
    public var transactions: [TransactionModel]?

    // Initialiseur
    public init(
        id: Int,
        name: String,
        amount: Double,
        type: TransactionType,
        frequency: SubscriptionFrequency,
        frequencyDate: Date,
        categoryID: Int,
        subcategoryID: Int? = nil,
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
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.firstSubscriptionDate = firstSubscriptionDate
        self.lastSubscriptionDate = lastSubscriptionDate
        self.transactions = transactions
    }
    
}
