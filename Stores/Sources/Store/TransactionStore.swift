//
//  TransactionStore.swift
//  Core
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Dependencies
import Models
import NetworkModule
import Events

@Observable
public final class TransactionStore {
    public static let shared = TransactionStore()
    
    public var transactions: [TransactionModel] = []
    
    public var currentDateForFetch: Date = Date()
    public var dateFetched: [Date] = []
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
  
  func sortTransactionsByDate() {
      self.transactions.sort { $0.date > $1.date }
  }
    
}

extension Date {
  var oneMonthAgo: Date {
      return Calendar.current.date(byAdding: .month, value: -1, to: self)!
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

public extension EventService {
    
    @MainActor
    private static func sendTransactionTypeEvent(type: TransactionType) {
        if type == .expense {
            EventService.sendEvent(key: EventKeys.transactionExpenseCreated)
        } else if type == .income {
            EventService.sendEvent(key: EventKeys.transactionIncomeCreated)
        }
    }
    
    @MainActor
    private static func sendApplePayEvent(isFromApplePay: Bool) {
        if isFromApplePay {
            EventService.sendEvent(key: EventKeys.transactionCreatedApplePay)
        }
    }
    
    @MainActor
    static func sendForTransactionCreated(transaction: TransactionModel) {
        EventService.sendEvent(key: EventKeys.transactionCreated)
        EventService.sendTransactionTypeEvent(type: transaction.type)
        EventService.sendApplePayEvent(isFromApplePay: transaction.isFromApplePay)
    }
    
}
