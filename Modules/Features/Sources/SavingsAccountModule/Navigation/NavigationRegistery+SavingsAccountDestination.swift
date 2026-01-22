//
//  NavigationRegistery+SavingsAccountDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation
import AccountModule

public extension NavigationRegistry {
    
    func registerSavingsAccountRoutes() {
        self.register(SavingsAccountDestination.self) { destination in
            switch destination {
            case .create:
                AnyView(AddAccountScreen(type: .savings))
            case .update(let account):
                AnyView(AddAccountScreen(type: .savings, account: account))
            case .list:
                AnyView(SavingsAccountsListView())
            case .detail:
                AnyView(SavingsAccountDetailScreen())
            case .createTransaction(let savingsAccount, let transaction):
                AnyView(CreateTransactionForSavingsAccountScreen(savingsAccount: savingsAccount, transaction: transaction))
            }
        }
    }
    
}
