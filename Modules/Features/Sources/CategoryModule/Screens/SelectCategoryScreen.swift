//
//  SelectCategoryScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import Core
import Models
import Stores
import DesignSystem

public struct SelectCategoryScreen: View {
    
    // MARK: Dependencies
    @Binding var selectedCategory: CategoryModel?
    @Binding var selectedSubcategory: SubcategoryModel?
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: States
    @State private var viewModel: ViewModel = .init()
    
    // MARK: Init
    public init(
        selectedCategory: Binding<CategoryModel?>,
        selectedSubcategory: Binding<SubcategoryModel?>
    ) {
        self._selectedCategory = selectedCategory
        self._selectedSubcategory = selectedSubcategory
    }
    
    // MARK: - View
    public var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: .small) {
                    
                    SearchBarView("Rechercher", searchText: $viewModel.searchText) // TODO: TBL
                }
                
                VStack(spacing: Spacing.extraLarge) {
                    ForEach(viewModel.categoriesFiltered) { category in
                        categorySectionView(for: category)
                    }
                }
            }
            .fullSize()
            .contentMargins(.all, Spacing.large, for: .scrollContent)
            .background(Color.Background.bg50)
            .scrollIndicators(.hidden)
            .overlay(condition: !viewModel.searchText.isEmpty && viewModel.categoriesFiltered.isEmpty) {
                CustomEmptyView(type: .noResults(viewModel.searchText), isPlain: true)
            }
            .navigationTitle("what_category_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    DismissButtonView()
                }
            }
        }
    }
}

// MARK: - Subviews
extension SelectCategoryScreen {
    
    private func categorySectionView(for category: CategoryModel) -> some View {
        VStack(spacing: Spacing.standard) {
            Text(category.name)
                .font(.Title.medium)
                .fullWidth(.leading)
            
            if category.subcategories == nil || category.subcategories?.isEmpty == true {
                categoryView(for: category)
            } else {
                subcategoriesView(for: category)
            }
        }
    }
    
    private func categoryView(for category: CategoryModel) -> some View {
        CategorySelectableRowView(
            category: category,
            isSelected: selectedCategory == category
        ) {
            withAnimation {
                selectedSubcategory = nil
                selectedCategory = category
                dismiss()
            }
        }
    }
    
    private func subcategoriesView(for category: CategoryModel) -> some View {
        VStack(spacing: Spacing.small) {
            ForEach(viewModel.subcategoriesFiltered(for: category)) { subcategory in
                SubcategorySelectableRowView(
                    subcategory: subcategory,
                    isSelected: selectedSubcategory == subcategory
                ) {
                    withAnimation {
                        selectedCategory = category
                        selectedSubcategory = subcategory
                        dismiss()
                    }
                }
            }
        }
    }
    
}

// MARK: - Preview
// struct WhatCategoryView_Previews: PreviewProvider {
//
//    @State static var selectedCategoryPreview: ? = previewCategory1()
//    @State static var selectedSubcategoryPreview: ? =
//
//    static var previews: some View {
//        SelectCategoryScreen(selectedCategory: $selectedCategoryPreview, selectedSubcategory: )
//    }
// }
