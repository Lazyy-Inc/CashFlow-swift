//
//  SubcategoryTransactionData.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import Foundation
import Models

public struct SubcategoryTransactionData {
    public let subcategory: SubcategoryModel
    public let transactions: [TransactionModel]
    public let totalAmount: Double
    
    public init(subcategory: SubcategoryModel, transactions: [TransactionModel]) {
        self.subcategory = subcategory
        self.transactions = transactions
        self.totalAmount = transactions.map(\.amount).reduce(0, +)
    }
}
