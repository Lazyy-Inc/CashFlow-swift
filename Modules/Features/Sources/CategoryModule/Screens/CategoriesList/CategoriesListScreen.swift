//
//  CategoriesListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import Navigation
import DesignSystem
import Core
import Stores

public struct CategoriesListScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.accountStore) private var accountStore: AccountStore
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.categoryStore) var categoryStore
    
    // MARK: StateObject
    @StateObject private var viewModel: ViewModel = .init()
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        ListWithBluredHeader(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: "word_categories".localized,
                withDismiss: true,
                placeholder: "word_search".localized,
                searchText: $viewModel.searchText.animation()
            )
        } content: {
            if viewModel.categoriesFiltered.isNotEmpty {
                categoriesChartView()
                    .padding(.horizontal, Padding.large)
                    .padding(.bottom, Padding.large)
                
                categoriesListView()
                    .padding(.horizontal, Padding.large)
                
                Rectangle()
                    .frame(height: 100)
                    .opacity(0)
                    .noDefaultStyle()
            } else {
                CustomEmptyView(type: .noResults(viewModel.searchText), isPlain: true)
                    .noDefaultStyle()
            }
        }
        
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
        .refreshable {
            await categoryStore.fetchCategories()
        }
        .task(id: viewModel.selectedDate) {
            if let account = accountStore.selectedAccount, let accountID = account._id {
                await transactionStore.fetchTransactionsByPeriod(
                    accountId: accountID,
                    period: .init(
                        startDate: viewModel.selectedDate.startOfMonth ?? .now,
                        endDate: viewModel.selectedDate.endOfMonth ?? .now
                    )
                )
            }
        }
    }
}

// MARK: - Subviews
extension CategoriesListScreen {
    
    @ViewBuilder
    func categoriesChartView() -> some View {
        VStack(spacing: .standard) {
            MonthPickerView(selectedMonth: $viewModel.selectedDate)
                .buttonStyle(PlainButtonStyle())
                .padding(.standard)
                .roundedBackground(.classic)
                .noDefaultStyle()
            
            if !viewModel.isChartDisplayed {
                CustomEmptyView(type: .noCategoryData, isPlain: true)
                    .padding(8)
                    .noDefaultStyle()
            } else if viewModel.searchText.isEmpty {
                CategoryChartView(items: viewModel.transactionsByCategory, selectedMonth: viewModel.selectedDate)
                    .noDefaultStyle()
            }
        }
        .noDefaultStyle()
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func categoriesListView() -> some View {
        VStack(spacing: Spacing.medium) {
            ForEach(viewModel.categoriesFiltered) { category in
                let subcategories = category.subcategories
                NavigationButtonView(
                    route: .push,
                    destination: (
                        subcategories?.isEmpty == false
                        ? AppDestination.subcategory(.list(category: category, selectedDate: viewModel.selectedDate))
                        : AppDestination.category(.transactions(category: category, selectedDate: viewModel.selectedDate))
                    ),
                    label: {
                        CategoryRowView(
                            category: category,
                            selectedDate: viewModel.selectedDate
                        )
                    }
                )
                .buttonStyle(PlainButtonStyle())
            }
        }
        .noDefaultStyle()
    }
}

// MARK: - Preview
#Preview {
    CategoriesListScreen()
}
