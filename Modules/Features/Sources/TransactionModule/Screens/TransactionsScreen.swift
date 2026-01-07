//
//  TransactionsView.swift
//  CashFlow
//
//  Created by Théo Sementa on 03/07/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import Navigation
import Core
import DesignSystem
import Dependencies
import Stores

public struct TransactionsScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    
    // Environement
    @EnvironmentObject private var router: Router<AppDestination>
    
    public init() { }
            
    // MARK: -
    public var body: some View {
        VStack(spacing: 0) {
            NavigationBar(
                title: Word.Main.transactions,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.transaction(.create)) },
                    isDisabled: false
                )
            )
            TransactionsListScreen()
                .emptyState(condition: transactionStore.transactions.isEmpty) {
                    CustomEmptyView(type: .noTransactions, isPlain: true)
                }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsScreen()
}
