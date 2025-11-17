//
//  SubcategoryListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Navigation
import TheoKit
import DesignSystem
import Core
import Dependencies
import Models
import Stores

public struct SubcategoryListScreen: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    
    // MARK: Environnements
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.categoryStore) private var categoryStore
    
    // MARK: StateObject
    @StateObject private var viewModel: ViewModel = .init()
    
    // Computed
    var searchResults: [SubcategoryModel] {
        let subcategories = viewModel.searchText.isEmpty
            ? (category.subcategories ?? [])
            : (category.subcategories?.filter { $0.name.localizedStandardContains(viewModel.searchText) } ?? [])
        
        return subcategories.sorted { subcat1, subcat2 in
            if subcat2.name == "word_others".localized {
                return true
            }
            if subcat1.name == "word_others".localized {
                return false
            }
            return subcat1.name < subcat2.name
        }
    }
    
    public init(category: CategoryModel, selectedDate: Date) {
        self.category = category
        self.selectedDate = selectedDate
    }
    
    // MARK: - View
    public var body: some View {
        ListWithBluredHeader(maxBlurRadius: Blur.topbar) {
            NavigationBar(title: "word_subcategories".localized)
        } content: {
          VStack(spacing: 24) {
            if !viewModel.isDisplayChart(category: category) {
                CustomEmptyView(type: .empty(.emptyCategory), isDisplayed: true)
                    .padding(8)
                    .noDefaultStyle()
            } else if viewModel.searchText.isEmpty {
              PieChart(
                month: selectedDate,
                slices: categoryStore.subcategoriesSlices(for: category, in: selectedDate),
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
          
          ForEach(searchResults) { subcategory in
            NavigationButtonView(
              route: .push,
              destination: AppDestination.subcategory(
                .transactions(
                  subcategory: subcategory,
                  selectedDate: selectedDate
                )
              )
            ) {
              SubcategoryRowView(subcategory: subcategory, selectedDate: selectedDate)
            }
            .padding(.bottom, Spacing.medium)
            .padding(.horizontal, Padding.large)
          }
          .noDefaultStyle()
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
    }
}

// MARK: - Preview
#Preview {
    SubcategoryListScreen(category: .mock, selectedDate: .now)
}
