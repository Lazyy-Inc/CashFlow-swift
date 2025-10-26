//
//  AccountStore.swift
//  Core
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Models
import NetworkModule
import Preferences
import Events
import Repositories
import Dependencies

@Observable
public final class AccountStore {
    public static let shared = AccountStore()
    
    public var accounts: [AccountModel] = []
    public var savingsAccounts: [AccountModel] = []
    public var classicAccounts: [AccountModel] = []
    
    public var selectedAccount: AccountModel?
    
    public var cashflow: [Double] = []
    public var stats: StatisticsModel?
    
    public var allAccounts: [AccountModel] {
        return accounts + savingsAccounts
    }
}

public extension AccountStore {
    
    var savingsAmount: Double {
        return savingsAccounts
            .map(\.balance)
            .reduce(0, +)
    }
    
}

public extension AccountStore {
    
    func findByID(_ id: Int?) -> AccountModel? {
        return self.allAccounts.first(where: { $0._id == id })
    }
    
    func setNewBalance(accountID: Int, newBalance: Double) {
        if let accountIndex = accounts.firstIndex(where: { $0._id == accountID }) {
            self.accounts[accountIndex]._balance = newBalance
            if let selectedAccount, selectedAccount._id == accountID {
                self.selectedAccount?._balance = newBalance
            }
        } else if let savingsAccountIndex = savingsAccounts.firstIndex(where: { $0._id == accountID }) {
            self.savingsAccounts[savingsAccountIndex]._balance = newBalance
        }
    }
    
    func setNewAccount(account: AccountModel?) {
        guard let account else { return }
        self.selectedAccount = account
    }
    
}

public extension AccountStore {
    
    @MainActor
    func fetchAccounts() async {
        do {
            let accounts = try await AccountService.fetchAll()
            
            self.accounts = accounts.filter { $0.type == AccountType.classic }
            self.classicAccounts = accounts.filter { $0.type == AccountType.classic }
            self.savingsAccounts = accounts.filter { $0.type == AccountType.savings }
          
            let localAccounts = try await AccountRepository.fetchAll()
            if localAccounts.isEmpty {
              for account in accounts {
                guard let remoteId = account._id else { continue }
                AccountRepository.create(remoteId: remoteId, name: account.name)
              }
            }

            if let account = findByID(AccountPreferences.shared.mainAccountId) {
                self.selectedAccount = account
            } else {
                self.selectedAccount = self.accounts.sorted { $0.createdAt ?? .now < $1.createdAt ?? .now }.first
                AccountPreferences.shared.mainAccountId = self.selectedAccount?._id ?? 0
            }
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createAccount(body: AccountModel) async -> AccountModel? {
        do {
            let account = try await AccountService.create(body: body)
            if let remoteId = account._id {
              AccountRepository.create(remoteId: remoteId, name: account.name)
            }
          
            if account.type == AccountType.classic {
                self.accounts.append(account)
                if selectedAccount == nil {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        self.selectedAccount = account
                    }
                }
                
                EventService.sendEvent(key: EventKeys.accountClassicCreated)
            } else if account.type == AccountType.savings {
                self.savingsAccounts.append(account)
                EventService.sendEvent(key: EventKeys.accountSavingsCreated)
            }
            return account
        } catch {
            await NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateAccount(accountID: Int, body: AccountModel) async {
        do {
            let account = try await AccountService.update(id: accountID, body: body)
            
            if account.type == AccountType.classic {
                if let index = self.accounts.firstIndex(where: { $0._id == accountID }) {
                    self.accounts[index] = account
                    if selectedAccount?._id == accountID {
                        selectedAccount = nil
                        selectedAccount = self.accounts[index]
                    }
                }
            } else if account.type == AccountType.savings {
                if let index = self.savingsAccounts.firstIndex(where: { $0._id == accountID }) {
                    self.savingsAccounts[index] = account
                }
            }
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteAccount(accountID: Int) async {
        do {
            try await AccountService.delete(id: accountID)
            
            if accounts.contains(where: { $0._id == accountID }) {
                EventService.sendEvent(key: EventKeys.accountClassicDeleted)
            } else if savingsAccounts.contains(where: { $0._id == accountID }) {
                EventService.sendEvent(key: EventKeys.accountSavingsDeleted)
            }
            
            self.accounts.removeAll { $0._id == accountID }
            self.savingsAccounts.removeAll { $0._id == accountID }
            
            if selectedAccount?._id == accountID {
                TransactionStore.shared.reset()
                SubscriptionStore.shared.reset()
                SavingsPlanStore.shared.reset()
                BudgetStore.shared.reset()
                selectedAccount = nil
            }
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchCashFlow(accountID: Int, year: Int) async {
        do {
            self.cashflow = try await AccountService.fetchCashFlow(id: accountID, year: year)
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchStats(accountID: Int, withSavings: Bool) async {
        do {
            self.stats = try await AccountService.fetchStats(id: accountID, withSavings: withSavings)
        } catch { await NetworkService.handleError(error: error) }
    }
  
}

extension AccountStore {
    
    public func reset() {
        self.accounts.removeAll()
        self.savingsAccounts.removeAll()
        self.classicAccounts.removeAll()
    }
    
}

// MARK: - Dependencies
extension AccountStore: DependencyKey {
    public static var liveValue: AccountStore = .shared
}

public extension DependencyValues {
    var accountStore: AccountStore {
        get { self[AccountStore.self] }
        set { self[AccountStore.self] = newValue }
    }
}
