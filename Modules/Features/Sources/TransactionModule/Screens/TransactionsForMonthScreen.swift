//
//  TransactionsForMonthScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import Navigation
import Core
import DesignSystem
import Models
import Providers

public struct TransactionsForMonthScreen: View {
    
    // MARK: Dependencies
    var selectedDate: Date
    var type: FinancialItemType
    
    // MARK: States
    @State private var searchText: String = ""
    
    // MARK: Constants
    private let transactionDataSource: TransactionProvider
    
    // MARK: Init
    public init(
        selectedDate: Date,
        type: FinancialItemType,
        transactionDataSource: TransactionProvider = DefaultTransactionProvider.shared
    ) {
        self.selectedDate = selectedDate
        self.type = type
        self.transactionDataSource = transactionDataSource
    }
    
    // MARK: -
    public var body: some View {
        let transactions: [TransactionModel] = transactionDataSource.transactions(for: .type(type, month: selectedDate))
        let transactionsFiltered = transactions.search(searchText)
        
        List {
            Section(content: {
                ForEach(transactionsFiltered) { transaction in
                    NavigationButtonView(
                        route: .fullScreenCover,
                        destination: .transaction(.detail(transactionId: transaction.id))) {
                            FinancialItemRowView(financialItem: transaction)
                        }
                }
                .padding(.horizontal)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 4, leading: 0, bottom: 4, trailing: 0))
                .listRowBackground(Color.Background.bg50.edgesIgnoringSafeArea(.all))
            }, header: {
                DetailOfExpensesAndIncomesByMonth(
                    month: selectedDate,
                    amountOfExpenses: 0,
                    amountOfIncomes: 0
                )
                .listRowInsets(EdgeInsets(top: 4, leading: 0, bottom: 4, trailing: 0))
            })
            .foregroundStyle(Color.Text.primary)
        }
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .scrollIndicators(.hidden)
        .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
        .animation(.smooth, value: transactionsFiltered.count)
        .emptyState(condition: transactionsFiltered.isEmpty) {
            CustomEmptyView(
                type: transactionsFiltered.isEmpty && !searchText.isEmpty ? .noResults(searchText) : .noTransactions,
                isPlain: true
            )
        }
        .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
        .navigationTitle(Word.Main.transactions)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText, prompt: "word_search".localized)
        .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    TransactionsForMonthScreen(selectedDate: .now, type: .expense)
}
