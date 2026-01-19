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
import DataSources

public struct TransactionsScreen: View {
    
    // MARK: Environements
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: Constants
    private let transactionDataSource: TransactionDataSource
    
    // MARK: Init
    public init(transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared) {
        self.transactionDataSource = transactionDataSource
    }
            
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
                .emptyState(condition: transactionDataSource.transactions.isEmpty) {
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
