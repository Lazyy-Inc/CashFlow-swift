//
//  EmptyViewType.swift
//  Models
//
//  Created by Theo Sementa on 19/10/2025.
//

import Foundation

public enum EmptyViewType {
    case noAccounts
    case noTransactions
    case noBudgets
    case noSubscriptions
    case noFinancialGoals
    case noSavingsAccounts
//    case noResults(_ searchText: String)
}

public extension EmptyViewType {
    
    var title: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_title"
        case .noTransactions:
            "empty_transaction_title"
        case .noBudgets:
            "empty_budget_title"
        case .noSubscriptions:
            "empty_subscription_title"
        case .noFinancialGoals:
            "empty_financial_goal_title"
        case .noSavingsAccounts:
            "empty_savings_account_title"
//        case .noResults(let searchText):
//            ""
        }
    }
    
    var description: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_desc"
        case .noTransactions:
            "empty_transaction_desc"
        case .noBudgets:
            "empty_budget_desc"
        case .noSubscriptions:
            "empty_subscription_desc"
        case .noFinancialGoals:
            "empty_financial_goal_desc"
        case .noSavingsAccounts:
            "empty_savings_account_desc"
//        case .noResults:
//            ""
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_button"
        case .noTransactions:
            "empty_transaction_button"
        case .noBudgets:
            "empty_budget_button"
        case .noSubscriptions:
            "empty_subscription_button"
        case .noFinancialGoals:
            "empty_financial_goal_button"
        case .noSavingsAccounts:
            "empty_savings_account_button"
//        case .noResults:
//            ""
        }
    }
    
    var icon: String {
        switch self {
        case .noAccounts:
            "iconPerson"
        case .noTransactions:
            "iconBanknote"
        case .noBudgets:
            "iconPieChart"
        case .noSubscriptions:
            "iconClockRepeat"
        case .noFinancialGoals:
            "iconPiggyBank"
        case .noSavingsAccounts:
            "iconLandmark"
        }
    }
    
}
