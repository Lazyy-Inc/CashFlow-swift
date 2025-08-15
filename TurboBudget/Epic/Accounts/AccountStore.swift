//
//  AccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation
import NetworkKit
import StatsKit
import CoreModule
import EventModule
import SavingsPlanModule

extension AccountStore {
    
    @MainActor
    func fetchAccounts() async {
        do {
            let accounts = try await AccountService.fetchAll()
            
            self.accounts = accounts.filter { $0.type == AccountType.classic }
            self.classicAccounts = accounts.filter { $0.type == AccountType.classic }
            self.savingsAccounts = accounts.filter { $0.type == AccountType.savings }

            if let account = findByID(AccountPreferences.shared.mainAccountId) {
                self.selectedAccount = account
            } else {
                self.selectedAccount = self.accounts.sorted { $0.createdAt ?? .now < $1.createdAt ?? .now }.first
                AccountPreferences.shared.mainAccountId = self.selectedAccount?._id ?? 0
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createAccount(body: AccountModel) async -> AccountModel? {
        do {
            let account = try await AccountService.create(body: body)
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
            NetworkService.handleError(error: error)
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
        } catch { NetworkService.handleError(error: error) }
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
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchCashFlow(accountID: Int, year: Int) async {
        do {
            self.cashflow = try await AccountService.fetchCashFlow(id: accountID, year: year)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func fetchStats(accountID: Int, withSavings: Bool) async {
        do {
            self.stats = try await AccountService.fetchStats(id: accountID, withSavings: withSavings)
        } catch { NetworkService.handleError(error: error) }
    }
}

extension AccountStore {
    
    func cashFlowAmount(for month: Date) -> Double {
        let monthNum = month.month - 1
        if cashflow.isNotEmpty {
            return cashflow[monthNum]
        } else { return 0 }
    }
    
}
