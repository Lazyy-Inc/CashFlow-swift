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

public struct SelectCategoryScreen: View {
  
  // MARK: Dependencies
  @Binding var selectedCategory: CategoryModel?
  @Binding var selectedSubcategory: SubcategoryModel?
  
  // MARK: Environments
  @EnvironmentObject private var themeManager: ThemeManager
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
      .scrollIndicators(.hidden)
      .overlay {
        if !viewModel.searchText.isEmpty && viewModel.categoriesFiltered.isEmpty {
          VStack(spacing: 20) {
            Image("NoResults\(themeManager.theme.nameNotLocalized.capitalized)")
              .resizable()
              .aspectRatio(contentMode: .fit)
              .shadow(radius: 4, y: 4)
              .frame(width: UIDevice.isIpad
                     ? UIScreen.main.bounds.width / 3
                     : UIScreen.main.bounds.width / 1.5
              )
            
            Text("word_no_results".localized + " '\(viewModel.searchText)'")
              .font(.semiBoldText16())
              .multilineTextAlignment(.center)
          }
          .offset(y: -20)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
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
