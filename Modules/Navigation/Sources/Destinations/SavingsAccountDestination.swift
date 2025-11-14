//
//  SavingsAccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import NavigationKit
import Models

public enum SavingsAccountDestination: DestinationItem {
    case create
    case update(savingsAccount: AccountModel)
    case list
    case detail(savingsAccount: AccountModel)
    case createTransaction(savingsAccount: AccountModel, transaction: TransactionModel? = nil)
}
