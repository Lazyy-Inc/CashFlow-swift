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
    case noSubscriptions
    case noFinancialGoals
    case noSavingsAccounts
    case noCategoryData
    case noRepartitionStats
    case noAnalysis
    case noResults(_ searchText: String)
}
