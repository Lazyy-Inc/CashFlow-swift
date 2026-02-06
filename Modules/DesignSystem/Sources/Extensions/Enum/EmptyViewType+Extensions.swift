//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 17/11/2025.
//

import Foundation
import Models
import Core

public extension EmptyViewType {
    
    var title: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_title"
        case .noTransactions:
            "empty_transaction_title"
        case .noSubscriptions:
            "empty_subscription_title"
        case .noFinancialGoals:
            "empty_financial_goal_title"
        case .noSavingsAccounts:
            "empty_savings_account_title"
        case .noCategoryData:
            "error_message_no_data_month"
        case .noRepartitionStats:
            "statistics_charts_lock_title"
        case .noAnalysis:
            "empty_stats_title"
        case .noResults(let searchText):
            "word_no_results".localized + " " + "\"\(searchText)\""
        }
    }
    
    var description: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_desc"
        case .noTransactions:
            "empty_transaction_desc"
        case .noSubscriptions:
            "empty_subscription_desc"
        case .noFinancialGoals:
            "empty_financial_goal_desc"
        case .noSavingsAccounts:
            "empty_savings_account_desc"
        case .noCategoryData:
            ""
        case .noRepartitionStats:
            "statistics_charts_lock_desc"
        case .noAnalysis:
            "empty_stats_list_description"
        case .noResults:
            "empty_search_description"
        
        }
    }
    
    var buttonTitle: String {
        switch self {
        case .noAccounts:
            "empty_bank_account_button"
        case .noTransactions:
            "empty_transaction_button"
        case .noSubscriptions:
            "empty_subscription_button"
        case .noFinancialGoals:
            "empty_financial_goal_button"
        case .noSavingsAccounts:
            "empty_savings_account_button"
        case .noRepartitionStats:
            ""
        case .noAnalysis:
            "empty_transaction_button"
        case .noCategoryData:
            ""
        case .noResults:
            ""
        }
    }
    
    var icon: String {
        switch self {
        case .noAccounts:
            "iconPerson"
        case .noTransactions:
            "iconBanknote"
        case .noSubscriptions:
            "iconClockRepeat"
        case .noFinancialGoals:
            "iconPiggyBank"
        case .noSavingsAccounts:
            "iconLandmark"
        case .noCategoryData:
            "iconPieChart"
        case .noRepartitionStats:
            "iconLineChart"
        case .noAnalysis:
            "iconLineChart"
        case .noResults:
            "iconSearch"
        }
    }
    
}
