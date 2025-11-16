//
//  HomeScreenRecentTransactionsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import Navigation
import TheoKit
import DesignSystem
import Preferences
import Core
import TransactionModule
import Dependencies
import Models
import Stores

struct HomeScreenRecentTransactionsView: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: Computed variables
    var transactions: [TransactionModel] {
        return Array(transactionStore.transactions.prefix(preferencesDisplayHome.transaction_value))
    }
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.standard) {
            HomeScreenComponentHeaderView(type: .recentTransactions)
            
            if transactionStore.transactions.isNotEmpty {
                VStack(spacing: Spacing.medium) {
                    ForEach(transactions) { transaction in
                        NavigationButtonView(
                            route: .push,
                            destination: .transaction(.detail(transactionId: transaction.id))
                        ) {
                            FinancialItemRowView(financialItem: transaction)
                        }
                    }
                }
            } else {
                CustomEmptyView(
                    type: .empty(.transactions(.home)),
                    isDisplayed: true
                )
            }
        }
        .isDisplayed(preferencesDisplayHome.transaction_isDisplayed)
    }
    
}

// MARK: - Preview
#Preview {
    HomeScreenRecentTransactionsView()
}
