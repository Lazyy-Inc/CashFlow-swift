//
//  SubscriptionDetailViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import Foundation
import Core
import Models
import Stores
import Dependencies

extension SubscriptionDetailsScreen {
    
    final class ViewModel: ObservableObject {
        @Published var selectedCategory: CategoryModel?
        @Published var selectedSubcategory: SubcategoryModel?
    }
    
}

extension SubscriptionDetailsScreen.ViewModel {
    
    @MainActor
    func updateCategory(subscriptionID: Int) {
        let subscriptionStore: SubscriptionStore = .shared
        @Dependency(\.categoryStore) var categoryStore
        
        var body: SubscriptionDTO = .init()
        
        if let selectedCategory, let newCategory = categoryStore.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = categoryStore.findSubcategoryById(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await subscriptionStore.updateSubscription(
                    subscriptionID: subscriptionID,
                    body: body
                )
                
                self.selectedCategory = nil
                self.selectedSubcategory = nil
            }
        }
    }
    
}
