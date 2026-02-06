//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI
import DesignSystem
import Models
import Navigation
import TransactionModule
import DataSources

struct HomeLastTransactionsSectionView: View {
        
    @Environment(Router<AppDestination>.self) private var router
    
    // MARK: Constants
    private let transactionDataSource: TransactionDataSource
    
    // MARK: Init
    init(transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared) {
        self.transactionDataSource = transactionDataSource
    }
    
    var lastTransactions: [TransactionModel] {
        var transactions: [TransactionModel] = []
        let transactionsOfTheMonth = transactionDataSource.transactions(for: .all(month: .now))
        transactions += transactionsOfTheMonth
        
        if transactionsOfTheMonth.count < 5 {
            let transactionsOfLastMonth = transactionDataSource.transactions(for: .all(month: .now.oneMonthAgo))
            transactions += transactionsOfLastMonth
        }
    
        transactions.sort { $0.date > $1.date }
        return Array(transactions.prefix(5))
    }
    
    // MARK: - View
    var body: some View {
        if lastTransactions.isNotEmpty {
            VStack(spacing: Spacing.medium) {
                HomeSectionHeaderView(
                    title: "home_last_transactions".localized,
                    destination: .transaction(.list)
                )
                
                ForEach(lastTransactions) { transaction in
                    NavigationButtonView(
                        route: .fullScreenCover,
                        destination: .transaction(.detail(transactionId: transaction.id))
                    ) {
                        FinancialItemRowView(financialItem: transaction)
                    }
                }
            }
        } else {
            CustomEmptyView(type: .noTransactions)
        }
    }
    
}

// MARK: - Preview
#Preview {
    HomeLastTransactionsSectionView()
}
