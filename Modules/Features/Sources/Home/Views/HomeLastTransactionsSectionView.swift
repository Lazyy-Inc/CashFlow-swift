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
import Dependencies

struct HomeLastTransactionsSectionView: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    var lastTransactions: [TransactionModel] {
        var transactions: [TransactionModel] = []
        let transactionsOfTheMonth = transactionStore.getTransactions(in: .now)
        transactions += transactionsOfTheMonth
        
        if transactionsOfTheMonth.count < 5 {
            let transactionsOfLastMonth = transactionStore.getTransactions(in: .now.oneMonthAgo)
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
                        route: .push,
                        destination: .transaction(.detail(transactionId: transaction.id))
                    ) {
                        FinancialItemRowView(financialItem: transaction)
                    }
                }
            }
        } else {
            CFEmptyView(type: .noTransactions)
        }
    }
    
}

// MARK: - Preview
#Preview {
    HomeLastTransactionsSectionView()
}
