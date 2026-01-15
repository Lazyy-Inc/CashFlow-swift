//
//  CategoryStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import Core
import Models
import Stores
import DataSources

public extension CategoryStore {
    
    private func computeCategoryData(for month: Date) -> [Int?: CategoryTransactionData] {
        let transactionDataSource = DefaultTransactionDataSource.shared
        let allMonthTransactions = transactionDataSource.transactions(for: .all(month: month))
        let transactionsByCategory = Dictionary(grouping: allMonthTransactions) { $0.category }
        
        return Dictionary(uniqueKeysWithValues: categories
            .compactMap { category in
                let categoryTransactions = transactionsByCategory[category, default: []]
                if categoryTransactions.isEmpty { return nil }
                return (
                    category.id,
                    CategoryTransactionData(
                        category: category,
                        transactions: categoryTransactions
                    )
                )
            })
    }
        
    func categoriesSlices(for month: Date) -> [PieSliceData] {
        let slices = computeCategoryData(for: month)
            .values
            .filter { !$0.category.isIncome }
            .map { data in
                PieSliceData(
                  title: data.category.name,
                    icon: data.category.icon,
                    value: data.totalAmount,
                    color: data.category.color
                )
            }
        return slices
    }

}

public extension CategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.category?.id == self.id }
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
    
}
