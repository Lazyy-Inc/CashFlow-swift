//
//  SubcategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

public struct SubcategoryModel: Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var icon: String
    public var color: Color
    public var isVisible: Bool
    
    public init(id: Int, name: String, icon: String, color: Color, isVisible: Bool) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.isVisible = isVisible
    }
}

public extension SubcategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.subcategory?.id == self.id }
    }
    
    /// Transactions of type expense in a Category
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    /// Transactions of type income in a Category
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    /// Transactions from Subscription in a Category
    var subscriptions: [TransactionModel] {
        return transactions.filter { $0.isFromSubscription == true }
    }
    
    var budget: BudgetModel? {
        return BudgetStore.shared.budgets.first(where: { $0.subcategoryID == self.id })
    }
    
}
