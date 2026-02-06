//
//  CategoryTransactionsScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import Navigation
import DesignSystem
import Core
import TransactionModule
import Stores
import Models
import DataSources

public struct CategoryTransactionsScreen: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    
    // MARK: Environments
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    
    // MARK: States
    @State private var searchText: String = ""
    @State private var amountExpense: Double = 0
    @State private var amountIncome: Double = 0
    
    // MARK: Constants
    private let transactionDataSource: TransactionDataSource
    
    // MARK: Init
    public init(
        category: CategoryModel,
        selectedDate: Date,
        transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared
    ) {
        self.category = category
        self.selectedDate = selectedDate
        self.transactionDataSource = transactionDataSource
    }
    
    // MARK: - View
    public var body: some View {
        let transactions = transactionDataSource.transactions(for: .category(category, month: selectedDate))
        let transactionsFiltered = transactions.search(searchText)
        
        List {
            Section(
                content: {
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
                },
                header: {
                    DetailOfExpensesAndIncomesByMonth(
                        month: selectedDate,
                        amountOfExpenses: amountExpense,
                        amountOfIncomes: amountIncome
                    )
                }
            )
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
        .navigationTitle(Word.Main.transactions)
        .navigationBarTitleDisplayMode(.large)
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
        .toolbar {
            ToolbarDismissPushButton()
        }
        .searchable(text: $searchText, prompt: "word_search".localized)
        .onAppear {
            if category.isIncome {
                amountIncome = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            } else {
                amountExpense = transactions
                    .compactMap(\.amount)
                    .reduce(0, +)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    CategoryTransactionsScreen(category: .mock, selectedDate: .now)
}
