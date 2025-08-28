//
//  AccountStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Models

public final class AccountStore: ObservableObject {
    public static let shared = AccountStore()
    
    @Published public var accounts: [AccountModel] = []
    @Published public var savingsAccounts: [AccountModel] = []
    @Published public var classicAccounts: [AccountModel] = []
    
    @Published public var selectedAccount: AccountModel?
    
    @Published public var cashflow: [Double] = []
    @Published public var stats: StatisticsModel?
    
    public var allAccounts: [AccountModel] {
        return accounts + savingsAccounts
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
