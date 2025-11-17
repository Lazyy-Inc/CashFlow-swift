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
    @Environment(\.theme) private var theme
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
                ForEach(viewModel.categoriesFiltered) { category in
                    VStack {
                        Text(category.name)
                            .font(.mediumCustom(size: 22))
                            .fullWidth(.leading)
                            .padding([.horizontal, .top])
                        
                        if category.subcategories == nil || category.subcategories?.isEmpty == true {
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
                        } else {
                            VStack {
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
                    .padding()
                }
                
                Rectangle()
                    .frame(height: 60)
                    .opacity(0)
                
                Spacer()
            }
            .background(Color.Background.bg50)
            .scrollIndicators(.hidden)
            .overlay(condition: !viewModel.searchText.isEmpty && viewModel.categoriesFiltered.isEmpty) {
                CFEmptyView(type: .noResults(viewModel.searchText), isPlain: true)
            }
            .navigationTitle("what_category_title".localized)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: { dismiss() }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.text)
                            .font(.system(size: 18, weight: .semibold))
                    })
                }
            }
        } // Navigation Stack
        .searchable(
            text: $viewModel.searchText.animation(),
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "word_search".localized
        )
    } // body
} // struct

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
