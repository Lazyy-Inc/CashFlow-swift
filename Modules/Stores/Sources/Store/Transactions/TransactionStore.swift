//
//  TransactionStore.swift
//  Core
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Models
import Networking
import Events
import Utilities

@Observable
public final class TransactionStore {
    public static let shared = TransactionStore()
    
    public var transactions: [TransactionModel] = []
    
    public var lastFetchedDate: Date = Date()
    public var dateFetched: [Date] = []
    
    // MARK: Constants
    private let accountStore: AccountStore = .shared
    private let transactionService: TransactionServiceProtocol
    
    // MARK: Init
    init(transactionService: TransactionServiceProtocol = TransactionService.shared) {
        self.transactionService = transactionService
    }
    
}

// MARK: - Network methods
public extension TransactionStore {
    
    func fetchTransactionsByPeriod(
        accountId: Int,
        period: PeriodDateModel,
        type: FinancialItemType? = nil
    ) async {
        guard isDateAlreadyFetched(period.startDate) == false else { return }
        
        do {
            let transactions = try await transactionService.fetchTransactionsByPeriod(
                accountID: accountId,
                period: period,
                type: type
            ).map { try $0.toModel() }
            
            await MainActor.run {
                addDateToFetchedDate(period.startDate)
                addUniqueTransactions(transactions)
                sortTransactionsByDate()
            }
            
            // EventService.sendEvent(key: EventKeys.transactionListPagination)
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @MainActor @discardableResult
    func createTransaction(
        accountId: Int,
        body: TransactionDTO,
        shouldStore: Bool = true
    ) async -> TransactionModel? {
        do {
            let response = try await transactionService.create(accountID: accountId, body: body)
            
            if let transaction = try response.transaction?.toModel(), let newBalance = response.newBalance {
                if shouldStore {
                    addUniqueTransactions([transaction])
                    sortTransactionsByDate()
                }
                accountStore.setNewBalance(accountID: accountId, newBalance: newBalance)
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
            let response = try await transactionService.update(transactionID: transactionId, body: body)
            
            if let transaction = try response.transaction?.toModel(),
               let newBalance = response.newBalance,
               let index = findIndex(for: transaction) {
                await MainActor.run {
                    self.transactions[index] = transaction
                    if sortTransaction { sortTransactionsByDate() }
                    accountStore.setNewBalance(accountID: accountId, newBalance: newBalance)
                    // EventService.sendEvent(key: EventKeys.transactionUpdated)
                }
                return transaction
            }
            return nil
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func fetchRecommendedCategory(
        name: String,
        transactionId: Int? = nil
    ) async -> TransactionFetchCategoryResponse? {
        do {
            return try await transactionService.fetchRecommendedCategory(
                name: name,
                transactionID: transactionId
            )
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func deleteTransaction(transactionId: Int) async {
        do {
            let response = try await transactionService.delete(transactionID: transactionId)
            
            if let index = self.transactions.firstIndex(where: { $0.id == transactionId }) {
                self.transactions.remove(at: index)
            }
            TransferStore.shared.transfers.removeAll { $0.id == transactionId }
            
            if let newBalance = response.newBalance, let account = accountStore.selectedAccount, let accountID = account._id {
                accountStore.setNewBalance(accountID: accountID, newBalance: newBalance)
            }
            
            // EventService.sendEvent(key: EventKeys.transactionDeleted)
        } catch { await NetworkService.handleError(error: error) }
    }
        
}

// MARK: - Public methods
public extension TransactionStore {
    
    func reset() {
        transactions.removeAll()
        dateFetched.removeAll()
        lastFetchedDate = .now
    }
    
    func sortTransactionsByDate() {
        self.transactions.sort { $0.date > $1.date }
    }
    
}

// MARK: - Private methods
private extension TransactionStore {
    
    /// Check if date already fetch by pagination
    func isDateAlreadyFetched(_ dateToFetch: Date) -> Bool {
        return dateFetched
            .filter { Calendar.current.isDate($0, equalTo: dateToFetch, toGranularity: .month) }
            .isNotEmpty
    }
    
    func addDateToFetchedDate(_ date: Date) {
        self.lastFetchedDate = date
        self.dateFetched.append(date)
    }
    
    func addUniqueTransactions(_ newTransactions: [TransactionModel]) {
        let existingIDs = Set(transactions.map(\.id))
        let uniqueTransactions = newTransactions.filter { !existingIDs.contains($0.id) }
        transactions.append(contentsOf: uniqueTransactions)
    }
    
    func findIndex(for transaction: TransactionModel) -> Int? {
        return transactions
            .firstIndex(where: { $0.id == transaction.id })
    }
    
}
