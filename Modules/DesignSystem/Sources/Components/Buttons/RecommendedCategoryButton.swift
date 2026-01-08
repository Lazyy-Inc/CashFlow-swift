//
//  RecommendedCategoryButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import Core
import Events
import Models
import Mocks
import Stores
import Dependencies

public struct RecommendedCategoryButton: View {
  
  // MARK: Dependencies
  var transactionName: String
  @Binding var selectedCategory: CategoryModel?
  @Binding var selectedSubcategory: SubcategoryModel?
  
  @Dependency(\.categoryStore) var categoryStore
  
  // MARK: States
  @State private var bestCategory: CategoryModel?
  @State private var bestSubcategory: SubcategoryModel?
  
  // MARK: Init
  public init(
    transactionName: String,
    selectedCategory: Binding<CategoryModel?>,
    selectedSubcategory: Binding<SubcategoryModel?>
  ) {
    self.transactionName = transactionName
    self._selectedCategory = selectedCategory
    self._selectedSubcategory = selectedSubcategory
  }
  
  // MARK: -
  public var body: some View {
    VStack {
      if let bestCategory {
        let subcategoryFound = bestSubcategory
        HStack(spacing: 8) {
          Text(Word.Classic.recommended + " : ")
            .font(.Label.large)
          
          HStack(spacing: 4) {
            Image(bestCategory.icon)
              .resizable()
              .renderingMode(.template)
              .frame(width: 20, height: 20)
            Text("\(bestSubcategory != nil ? (bestSubcategory!.name) : (bestCategory.name))")
              .font(.Body.small)
          }
          .fullWidth(.trailing)
          .foregroundStyle(bestCategory.color)
        }
        .padding(.horizontal, 8)
        .onTapGesture {
          selectedCategory = bestCategory
          if let subcategoryFound { selectedSubcategory = subcategoryFound }
          // EventService.sendEvent(key: EventKeys.autocatSuggestionAccepeted)
        }
      }
    }
    .onChange(of: transactionName) { _, newValue in
      if newValue.count > 3 {
        Task {
          if let response = await TransactionStore.shared.fetchRecommendedCategory(name: transactionName) {
            bestCategory = categoryStore.findCategoryById(response.cat)
            bestSubcategory = categoryStore.findSubcategoryById(response.sub)
          }
        }
      }
    }
  } // End body
} // End struct

// MARK: - Preview
#Preview {
  RecommendedCategoryButton(
    transactionName: "Test",
    selectedCategory: .constant(.mock),
    selectedSubcategory: .constant(.mock)
  )
}
