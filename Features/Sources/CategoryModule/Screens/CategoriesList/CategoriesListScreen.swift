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
import TheoKit
import DesignSystem
import Core
import Dependencies
import Stores

public struct CategoriesListScreen: View {
  
  // MARK: EnvironmentObject
  @EnvironmentObject private var accountStore: AccountStore
  @Dependency(\.transactionStore) private var transactionStore: TransactionStore
  @Dependency(\.categoryStore) var categoryStore
  @EnvironmentObject private var router: Router<AppDestination>
  
  // MARK: StateObject
  @StateObject private var viewModel: ViewModel = .init()
  
  public init() { }
  
  // MARK: -
  public var body: some View {
    VStack(spacing: 0) {
      ListWithBluredHeader(maxBlurRadius: Blur.topbar) {
        NavigationBar(
          title: "word_categories".localized,
          withDismiss: false,
          actionButton: .init(
            icon: "iconGear",
            action: { router.push(.settings(.home)) },
            isDisabled: false
          ),
          placeholder: "word_search".localized,
          searchText: $viewModel.searchText.animation()
        )
      } content: {
        if viewModel.categoriesFiltered.isNotEmpty {
          VStack(spacing: 24) {
            if !viewModel.isChartDisplayed {
              EmptyCategoryData()
                .padding(8)
                .noDefaultStyle()
            } else if viewModel.searchText.isEmpty {
              PieChart(
                month: viewModel.selectedDate,
                slices: categoryStore.categoriesSlices(for: viewModel.selectedDate),
                config: .init(
                  style: .category,
                  backgroundColor: Color.Background.bg100,
                  space: 0.2,
                  hole: 0.75
                )
              )
              .buttonStyle(PlainButtonStyle())
              .padding(8)
              .noDefaultStyle()
            }
            
            VStack(spacing: 8) {
              SwitchDateButton(date: $viewModel.selectedDate, type: .month)
                .buttonStyle(PlainButtonStyle())
              SwitchDateButton(date: $viewModel.selectedDate, type: .year)
                .buttonStyle(PlainButtonStyle())
            }
            .noDefaultStyle()
          }
          .noDefaultStyle()
          .padding(8)
          .frame(maxWidth: .infinity)
          .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
          )
          .padding(.horizontal, Padding.large)
          .padding(.bottom, Padding.large)
          
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
                    selectedDate: viewModel.selectedDate,
                    amount: (viewModel.categoryAmounts[category.id]?.amount ?? 0).toCurrency()
                  )
                }
              )
              .buttonStyle(PlainButtonStyle())
            }
          }
          .noDefaultStyle()
          .padding(.horizontal, Padding.large)
          
          Rectangle()
            .frame(height: 100)
            .opacity(0)
            .noDefaultStyle()
        } else {
          CustomEmptyView(
            type: .noResults(viewModel.searchText),
            isDisplayed: viewModel.categoriesFiltered.isEmpty && !viewModel.searchText.isEmpty
          )
          .noDefaultStyle()
        }
      }
    } // VStack
    .background(TKDesignSystem.Colors.Background.Theme.bg50)
    .onAppear {
      viewModel.calculateAllAmounts(for: viewModel.selectedDate)
    }
    .refreshable {
      await categoryStore.fetchCategories()
    }
    .onChange(of: viewModel.selectedDate) {
      if let account = accountStore.selectedAccount, let accountID = account._id {
        Task {
          await transactionStore.fetchTransactionsByPeriod(
            accountID: accountID,
            startDate: viewModel.selectedDate,
            endDate: viewModel.selectedDate.endOfMonth ?? .now
          )
          viewModel.calculateAllAmounts(for: viewModel.selectedDate)
        }
      }
    }
  } // body
} // struct

// MARK: - Preview
#Preview {
  CategoriesListScreen()
}
