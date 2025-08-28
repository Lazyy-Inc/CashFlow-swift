//
//  HomeScreenRecentTransactionsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/11/2024.
//

import SwiftUI
import Navigation
import TheoKit
import DesignSystemModule
import PreferenceModule
import CoreModule
import TransactionModule
import Dependencies
import Models
import Stores

struct HomeScreenRecentTransactionsView: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore

    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    var transactions: [TransactionModel] {
        return Array(transactionStore.transactions.prefix(preferencesDisplayHome.transaction_value))
    }
    
    // MARK: -
    var body: some View {
        if preferencesDisplayHome.transaction_isDisplayed {
            VStack(spacing: Spacing.standard) {
                HomeScreenComponentHeaderView(type: .recentTransactions)
                
                if transactionStore.transactions.isNotEmpty {
                    VStack(spacing: Spacing.medium) {
                        ForEach(transactions) { transaction in
                            NavigationButtonView(route: .push, destination: AppDestination.transaction(.detail(transaction: transaction))) {
                                TransactionRowView(transaction: transaction)
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
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenRecentTransactionsView()
}
