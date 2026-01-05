//
//  TransactionsListScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import Navigation
import TheoKit
import DesignSystem
import Core
import Dependencies
import Events
import Stores

struct TransactionsListScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    @State private var isLoading: Bool = false
    
    // MARK: -
    var body: some View {
        List(transactionStore.transactionsByMonth.sorted(by: { $0.key > $1.key }), id: \.key) { month, transactions in
            Section {
                ForEach(transactions) { transaction in
                    NavigationButtonView(
                        route: .push,
                        destination: .transaction(.detail(transactionId: transaction.id))
                    ) {
                        FinancialItemRowView(financialItem: transaction)
                    }
                    .id(transaction.id)
                    .padding(.bottom, Padding.medium)
                    .padding(.horizontal, Padding.large)
                    .onAppear {
                        if transactionStore.transactions.last?.id == transaction.id && !isLoading {
                            self.isLoading = true
                        }
                    }
                }
                .noDefaultStyle()
            } header: {
                DetailOfExpensesAndIncomesByMonth(
                    month: month,
                    amountOfExpenses: transactions.filter { $0.type == .expense }
                        .compactMap(\.amount)
                        .reduce(0, +),
                    amountOfIncomes: transactions.filter { $0.type == .income }
                        .compactMap(\.amount)
                        .reduce(0, +)
                )
                .padding(.horizontal, Padding.large)
            } // Section
            .listRowInsets(EdgeInsets())
        } // List
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .overlay(.bottom, condition: isLoading) {
            CashFlowLoader()
        }
        .animation(.smooth, value: transactionStore.transactions.count)
        .onChange(of: isLoading) { _, newValue in
            if newValue {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    Task {
                        if let selectedAccount = self.accountStore.selectedAccount, let accountID = selectedAccount._id {
                            let startDateOneMonthAgo = self.transactionStore.currentDateForFetch.oneMonthAgo
                            let endDateOneMonthAgo = startDateOneMonthAgo.endOfMonth ?? Date()
                            await self.transactionStore.fetchTransactionsByPeriod(
                                accountId: accountID,
                                period: .init(
                                  startDate: startDateOneMonthAgo,
                                  endDate: endDateOneMonthAgo
                                )
                            )
                            self.isLoading = false
                        }
                    }
                }
            }
        }
        .onAppear {
            EventService.sendEvent(key: EventKeys.transactionListPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsListScreen()
}
