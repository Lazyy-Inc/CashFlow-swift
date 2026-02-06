//
//  SubcategoryTransactionsScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Navigation
import DesignSystem
import Core
import TransactionModule
import Models
import DataSources

public struct SubcategoryTransactionsScreen: View {
    
    // MARK: Dependencies
    var subcategory: SubcategoryModel
    var selectedDate: Date
            
    // MARK: States
    @State private var searchText: String = ""
    
    // MARK: Constants
    private let transactionDataSource: TransactionDataSource
    
    public init(
        subcategory: SubcategoryModel,
        selectedDate: Date,
        transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared
    ) {
        self.subcategory = subcategory
        self.selectedDate = selectedDate
        self.transactionDataSource = transactionDataSource
    }
    
    // MARK: -
    public var body: some View {
        let transactionsExpenses = transactionDataSource.transactions(for: .subcategory(subcategory, month: selectedDate))
        let transactionsFiltered = transactionsExpenses.search(searchText)
        
        VStack(spacing: 0) {
            NavigationBar(
                title: Word.Main.transactions,
                placeholder: "word_search".localized,
                searchText: $searchText
            )
         
                List {
                    Section {
                        ForEach(transactionsFiltered) { transaction in
                            NavigationButtonView(
                                route: .fullScreenCover,
                                destination: AppDestination.transaction(.detail(transactionId: transaction.id))
                            ) {
                                FinancialItemRowView(financialItem: transaction)
                            }
                        }
                        .noDefaultStyle()
                        .padding(.bottom, Padding.medium)
                    } header: {
                        DetailOfExpensesAndIncomesByMonth(
                            month: selectedDate,
                            amountOfExpenses: transactionsExpenses.compactMap(\.amount).reduce(0, +),
                            amountOfIncomes: 0
                        )
                    }
                    .padding(.horizontal, Padding.large)
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .animation(.smooth, value: transactionsFiltered.count)
                .emptyState(condition: transactionsFiltered.isEmpty) {
                    CustomEmptyView(
                        type: transactionsFiltered.isEmpty && !searchText.isEmpty ? .noResults(searchText) : .noTransactions,
                        isPlain: true
                    )
                }
        }
        .scrollDismissesKeyboard(.interactively)
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SubcategoryTransactionsScreen(subcategory: .mock, selectedDate: .now)
}
