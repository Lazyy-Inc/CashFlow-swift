//
//  TransactionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation
import NetworkKit
import StatsKit
import CoreModule
import EventModule
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
    
    @MainActor
    func fetchTransactionsByPeriod(accountID: Int, startDate: Date, endDate: Date, type: TransactionType? = nil) async {
        guard dateFetched.filter({ Calendar.current.isDate($0, equalTo: startDate, toGranularity: .month) }).isEmpty else { return }
        
        do {
            let transactions = try await TransactionService.fetchTransactionsByPeriod(
                accountID: accountID,
                startDate: startDate,
                endDate: endDate,
                type: type
            ).map { try $0.toModel() }
            
            currentDateForFetch = startDate
            self.dateFetched.append(currentDateForFetch)
            
            self.transactions += transactions
            sortTransactionsByDate()
            
            EventService.sendEvent(key: EventKeys.transactionListPagination)
        } catch { NetworkService.handleError(error: error) }
    }
    
    /// Create transaction, add it to repository and optionally return it
    @discardableResult
    @MainActor
    func createTransaction(accountID: Int, body: TransactionDTO, shouldReturn: Bool = false, addInRepo: Bool = true) async -> TransactionModel? {
        do {
            let response = try await TransactionService.create(accountID: accountID, body: body)
            
            if let transaction = try response.transaction?.toModel(), let newBalance = response.newBalance {
                if addInRepo {
                    self.transactions.append(transaction)
                    sortTransactionsByDate()
                }
                AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
                EventService.sendForTransactionCreated(transaction: transaction)
                return shouldReturn ? transaction : nil
            }
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    /// Create transaction and optionally return it
    @discardableResult
    @MainActor
    func updateTransaction(accountID: Int, transactionID: Int, body: TransactionDTO, shouldReturn: Bool = false) async -> TransactionModel? {
        do {
            let response = try await TransactionService.update(transactionID: transactionID, body: body)
            
            if let transaction = try response.transaction?.toModel(), let newBalance = response.newBalance {
                if let index = self.transactions.map(\.id).firstIndex(of: transaction.id) {
                    self.transactions[index] = transaction
                    sortTransactionsByDate()
                    AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
                    EventService.sendEvent(key: EventKeys.transactionUpdated)
                    return shouldReturn ? transaction : nil
                }
            }
            return nil
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func fetchCategory(name: String, transactionID: Int? = nil) async -> TransactionFetchCategoryResponse? {
        do {
            return try await TransactionService.fetchRecommendedCategory(name: name, transactionID: transactionID)
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransaction(transactionID: Int) async {
        let accountRepo: AccountStore = .shared
        do {
            let response = try await TransactionService.delete(transactionID: transactionID)
            
            if let index = self.transactions.firstIndex(where: { $0.id == transactionID }) {
                self.transactions.remove(at: index)
            }
            TransferStore.shared.transfers.removeAll { $0.id == transactionID }
            
            if let newBalance = response.newBalance, let account = accountRepo.selectedAccount, let accountID = account._id {
                AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
            
            EventService.sendEvent(key: EventKeys.transactionDeleted)
        } catch { NetworkService.handleError(error: error) }
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

public extension TransactionDTO {
    
    func toModel() throws -> TransactionModel {
        guard let id,
              let amount,
              let dateISO
        else { throw NetworkError.unknown }
                
        let date = dateISO.toDate()
        let category = CategoryStore.shared.findCategoryById(categoryID)
        
        let subcategory = CategoryStore.shared.findSubcategoryById(subcategoryID)
        
        let senderAccount = AccountStore.shared.findByID(senderAccountID)
        let receiverAccount = AccountStore.shared.findByID(receiverAccountID)
        
        return .init(
            id: id,
            name: name ?? "",
            amount: amount,
            date: date ?? .now,
            creationDate: creationDate?.toDate(),
            category: category,
            subcategory: subcategory,
            note: note,
            isFromSubscription: isFromSubscription ?? false,
            isFromApplePay: isFromApplePay ?? false,
            nameFromApplePay: nameFromApplePay,
            autoCat: autoCat,
            senderAccount: senderAccount,
            receiverAccount: receiverAccount,
            address: address,
            lat: lat,
            long: long
        )
    }
}
