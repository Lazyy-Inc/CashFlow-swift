//
//  File.swift
//  Providers
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation
import Models
import Stores

public enum TransactionScope {
    case all(month: Date? = nil)
    case category(CategoryModel, month: Date? = nil)
    case subcategory(SubcategoryModel, month: Date? = nil)
    case type(FinancialItemType, category: CategoryModel? = nil, subcategory: SubcategoryModel? = nil, month: Date? = nil)
    case subscriptions(month: Date? = nil)
}

// MARK: - Protocol
public protocol TransactionProvider {
    var transactionStore: TransactionStore { get set }
    
    func transactions(matching filter: TransactionFilterModel) -> [TransactionModel]
    func transactions(for scope: TransactionScope) -> [TransactionModel]
}

// MARK: - Protocol extension
public extension TransactionProvider {
    
    var transactions: [TransactionModel] {
        transactionStore.transactions
    }
    
    func transactionsByCategories(for selectedMonth: Date) -> [CategoryModel: [TransactionModel]] {
        let transactions = transactions(for: .all(month: selectedMonth))
        let groupedByCategory = Dictionary(grouping: transactions) { $0.category }
        return Dictionary(uniqueKeysWithValues: groupedByCategory.compactMap { key, value in
            guard let key else { return nil }
            return (key, value)
        })
    }
    
    var transactionsByMonth: [Date: [TransactionModel]] {
        let groupedByMonth = Dictionary(grouping: transactions) { transaction in
            let components = Calendar.current.dateComponents([.month, .year], from: transaction.date)
            return Calendar.current.date(from: components)!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [TransactionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
    func transactionsByDay(in month: Date) -> [Date: [TransactionModel]] {
        let list = transactions(for: .all(month: month))
        return groupByDay(list)
    }
    
    func subscriptionTransactionsByDay(in month: Date) -> [Date: [TransactionModel]] {
        let list = transactions(for: .subscriptions(month: month))
        return groupByDay(list)
    }
    
}

// MARK: - Private Helper
private extension TransactionProvider {

    private func groupByDay(_ list: [TransactionModel]) -> [Date: [TransactionModel]] {
        Dictionary(grouping: list) { transaction in
            Calendar.current.startOfDay(for: transaction.date)
        }
    }
    
}
