//
//  CategoryTransactionData.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import Foundation

public struct CategoryTransactionData {
    public let category: CategoryModel
    public let transactions: [TransactionModel]
    public let totalAmount: Double
    
    public init(category: CategoryModel, transactions: [TransactionModel]) {
        self.category = category
        self.transactions = transactions
        self.totalAmount = transactions.map(\.amount).reduce(0, +)
    }
}
