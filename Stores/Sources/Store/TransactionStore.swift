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
    
}

public extension TransactionStore {
    
    func fetchTransactionsByPeriod(accountId: Int, period: PeriodDateModel, type: TransactionType? = nil) async {
        guard dateFetched.filter({ Calendar.current.isDate($0, equalTo: period.startDate, toGranularity: .month) }).isEmpty else { return }
        
        do {
            let transactions = try await TransactionService.fetchTransactionsByPeriod(
                accountID: accountId,
                period: period,
                type: type
            ).map { try $0.toModel() }
            
            await MainActor.run {
                currentDateForFetch = period.startDate
                self.dateFetched.append(currentDateForFetch)
                
                addUniqueTransactions(transactions)
                sortTransactionsByDate()
            }
            
            EventService.sendEvent(key: EventKeys.transactionListPagination)
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createTransaction(accountId: Int, body: TransactionDTO, shouldStore: Bool = true) async -> TransactionModel? {
        do {
            let response = try await TransactionService.create(accountID: accountId, body: body)
            
            if let transaction = try response.transaction?.toModel(), let newBalance = response.newBalance {
                if shouldStore {
                    addUniqueTransactions([transaction])
                    sortTransactionsByDate()
                }
                AccountStore.shared.setNewBalance(accountID: accountId, newBalance: newBalance)
                EventService.sendForTransactionCreated(transaction: transaction)
                return transaction
            }
            return nil
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    /// Create transaction and optionally return it
    @discardableResult
    func updateTransaction(
        accountId: Int,
        transactionId: Int,
        sortTransaction: Bool = false,
        body: TransactionDTO
    ) async -> TransactionModel? {
        do {
            let response = try await TransactionService.update(transactionID: transactionId, body: body)
            
            if let transaction = try response.transaction?.toModel(), let newBalance = response.newBalance {
                if let index = self.transactions.map(\.id).firstIndex(of: transaction.id) {
                    await MainActor.run {
                        self.transactions[index] = transaction
                        if sortTransaction { sortTransactionsByDate() }
                        AccountStore.shared.setNewBalance(accountID: accountId, newBalance: newBalance)
                        EventService.sendEvent(key: EventKeys.transactionUpdated)
                    }
                    return transaction
                }
            }
            return nil
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func fetchRecommendedCategory(name: String, transactionId: Int? = nil) async -> TransactionFetchCategoryResponse? {
        do {
            return try await TransactionService.fetchRecommendedCategory(name: name, transactionID: transactionId)
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransaction(transactionId: Int) async {
        let accountRepo: AccountStore = .shared
        do {
            let response = try await TransactionService.delete(transactionID: transactionId)
            
            if let index = self.transactions.firstIndex(where: { $0.id == transactionId }) {
                self.transactions.remove(at: index)
            }
            TransferStore.shared.transfers.removeAll { $0.id == transactionId }
            
            if let newBalance = response.newBalance, let account = accountRepo.selectedAccount, let accountID = account._id {
                AccountStore.shared.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
            
            EventService.sendEvent(key: EventKeys.transactionDeleted)
        } catch { await NetworkService.handleError(error: error) }
    }
}

public extension TransactionStore {
    
    func filterTransactions(filter: TransactionFilterModel) -> [TransactionModel] {
        return transactions.filter { transaction in
            let matchesCategory = filter.category.map { transaction.category == $0 } ?? true
            let matchesSubcategory = filter.subcategory.map { transaction.subcategory == $0 } ?? true
            let matchesMonth = filter.month.map { Calendar.current.isDate(transaction.date, equalTo: $0, toGranularity: .month) } ?? true
            let matchesType = filter.type.map { transaction.type == $0 } ?? true
            return matchesCategory && matchesSubcategory && matchesMonth && matchesType
        }
    }
    
    func getTransactions(in month: Date? = nil, type: TransactionType? = nil) -> [TransactionModel] {
        return filterTransactions(filter: .init(month: month, type: type))
    }
    
    func getTransactions(for category: CategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(filter: .init(category: category, month: month))
    }
    
    func getTransactions(for subcategory: SubcategoryModel, in month: Date? = nil) -> [TransactionModel] {
        return filterTransactions(filter: .init(subcategory: subcategory, month: month))
    }
    
    func reset() {
        transactions.removeAll()
        dateFetched.removeAll()
        currentDateForFetch = .now
    }
    
}

public extension TransactionStore {
    
    func fetchTransactionsOfCurrentMonth(accountID: Int) async {
        let startDate = Date().startOfMonth ?? .now
        let endDate = Date().endOfMonth ?? .now
        
        await self.fetchTransactionsByPeriod(
            accountId: accountID,
            period: .init(startDate: startDate, endDate: endDate)
        )
        
        if self.transactions.count < 5 {
            await self.fetchTransactionsByPeriod(
                accountId: accountID,
                period: .init(startDate: startDate.oneMonthAgo, endDate: endDate.oneMonthAgo)
            )
        }
    }
    
}

// MARK: - Utils
public extension TransactionStore {
    
    func sortTransactionsByDate() {
        self.transactions.sort { $0.date > $1.date }
    }
    
    func addUniqueTransactions(_ newTransactions: [TransactionModel]) {
        let existingIDs = Set(transactions.map(\.id))
        let uniqueTransactions = newTransactions.filter { !existingIDs.contains($0.id) }
        transactions.append(contentsOf: uniqueTransactions)
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
