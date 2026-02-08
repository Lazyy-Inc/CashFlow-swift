//
//  File.swift
//  Providers
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation
import Models
import Stores

public final class DefaultTransactionProvider: TransactionProvider, @unchecked Sendable {
    public static let shared = DefaultTransactionProvider()
    
    public var transactionStore: TransactionStore
    
    init(transactionStore: TransactionStore = .shared) {
        self.transactionStore = transactionStore
    }
    
}

extension DefaultTransactionProvider {
    
    public func transactions(matching filter: TransactionFilterModel) -> [TransactionModel] {
        return transactions.filter { transaction in
            let matchesCategory = filter.category.map { transaction.category == $0 } ?? true
            let matchesSubcategory = filter.subcategory.map { transaction.subcategory == $0 } ?? true
            let matchesType = filter.type.map { transaction.type == $0 } ?? true
            let matchesFromSubscription = filter.isFromSubscription.map { transaction.isFromSubscription == $0 } ?? true
            let matchesMonth = filter.month.map { Calendar.current.isDate(transaction.date, equalTo: $0, toGranularity: .month) } ?? true
            return matchesCategory && matchesSubcategory && matchesFromSubscription && matchesType && matchesMonth
        }
    }
    
    public func transactions(for scope: TransactionScope) -> [TransactionModel] {
        switch scope {
        case .all(let month):
            return transactions(matching: .init(month: month))
        case .category(let categoryModel, let month):
            return transactions(matching: .init(category: categoryModel, month: month))
        case .subcategory(let subcategoryModel, let month):
            return transactions(matching: .init(subcategory: subcategoryModel, month: month))
        case .type(let type, let category, let subcategory, let month):
            return transactions(matching: .init(category: category, subcategory: subcategory, type: type, month: month))
        case .subscriptions(let month):
            return transactions(matching: .init(isFromSubscription: true, month: month))
        }
    }
    
}
