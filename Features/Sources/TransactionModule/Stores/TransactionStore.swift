//
//  TransactionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation
import NetworkKit
import Core
import Events
import Stores
import Models
import NetworkModule

public extension TransactionStore {
    
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    var expensesCurrentMonth: [TransactionModel] {
        return expenses
            .filter { Calendar.current.isDate($0.date, equalTo: Date(), toGranularity: .month) }
    }
    
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    var transactionsByMonth: [Date: [TransactionModel]] {
        let groupedByMonth = Dictionary(grouping: transactions) { transaction in
            Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: transaction.date))!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [TransactionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
}

public extension TransactionStore {
    
    func fetchTransactionsOfCurrentMonth(accountID: Int) async {
        let startDate = Date().startOfMonth ?? .now
        let endDate = Date().endOfMonth ?? .now
        
        await self.fetchTransactionsByPeriod(
            accountID: accountID,
            startDate: startDate,
            endDate: endDate
        )
        
        if self.transactions.count < 15 {
            await self.fetchTransactionsByPeriod(
                accountID: accountID,
                startDate: startDate.oneMonthAgo,
                endDate: endDate.oneMonthAgo
            )
        }
    }
    
}

public extension TransactionStore {
    
    func getExpenses(transactions: [TransactionModel], in month: Date? = nil) -> [TransactionModel] {
        return transactions
            .filter { $0.type == .expense }
            .filter {
                if let month {
                    return Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
                } else { return true }
            }
    }
    
    func getExpenses(in month: Date? = nil) -> [TransactionModel] {
        let startDate = Date()
        let expenses = filterTransactions(inMonth: month, ofType: .expense)
        
        defer {
            let diff = Date().timeIntervalSince(startDate) * 1000
            NSLog("🤖 getExpenses took \(diff) ms")
        }
        
        return expenses
    }
    
    func getExpenses(for category: CategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return getTransactions(for: category, in: month)
            .filter { $0.type == .expense }
    }
    
    func getExpenses(for subcategory: SubcategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return getTransactions(for: subcategory, in: month)
//            .filter { $0.type == .expense }
    }
    
}

public extension TransactionStore {
    
    func getIncomes(transactions: [TransactionModel], in month: Date? = nil) -> [TransactionModel] {
        return transactions
            .filter { $0.type == .income }
            .filter {
                if let month {
                    return Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
                } else { return true }
            }
    }
    
    func getIncomes(in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(inMonth: month, ofType: .income)
    }
    
    func getIncomes(for category: CategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return getTransactions(for: category, in: month)
            .filter { $0.type == .income }
    }
    
    func getIncomes(for subcategory: SubcategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return getTransactions(for: subcategory, in: month)
            .filter { $0.type == .income }
    }
    
}

public extension TransactionStore {
    
    func getTransactionFromSubscriptions(in month: Date? = nil) -> [TransactionModel] {
        return getTransactions(in: month)
            .filter { $0.isFromSubscription == true }
    }
}
