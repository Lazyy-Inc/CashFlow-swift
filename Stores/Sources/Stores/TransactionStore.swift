//
//  TransactionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Dependencies
import Models

@Observable
public final class TransactionStore {
    public static let shared = TransactionStore()
    
    public var transactions: [TransactionModel] = []
    
    public var currentDateForFetch: Date = Date()
    public var dateFetched: [Date] = []
}

public extension TransactionStore {
    
    func getTransactions(in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(inMonth: month)
    }
    
    func getTransactions(for category: CategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(forCategory: category, inMonth: month)
    }
    
    func getTransactions(for subcategory: SubcategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(forSubcategory: subcategory, inMonth: month)
    }
    
    func reset() {
        transactions.removeAll()
        dateFetched.removeAll()
    }
    
}

public extension TransactionStore {
    
    func filterTransactions(
        forCategory category: CategoryModel? = nil,
        forSubcategory subcategory: SubcategoryModel? = nil,
        inMonth month: Date? = nil,
        ofType type: TransactionType? = nil
    ) -> [TransactionModel] {
        return transactions.filter { transaction in
            let matchesCategory = category.map { transaction.category == $0 } ?? true
            let matchesSubcategory = subcategory.map { transaction.subcategory == $0 } ?? true
            let matchesMonth = month.map { Calendar.current.isDate(transaction.date, equalTo: $0, toGranularity: .month) } ?? true
            let matchesType = type.map { transaction.type == $0 } ?? true
            return matchesCategory && matchesSubcategory && matchesMonth && matchesType
        }
    }
    
}

// MARK: - Dependencies
extension TransactionStore: DependencyKey {
    public static var liveValue: TransactionStore = .shared
}

public extension DependencyValues {
    var transactionStore: TransactionStore {
        get { self[TransactionStore.self] }
        set { self[TransactionStore.self] = newValue }
    }
}
