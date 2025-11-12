//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 30/09/2025.
//

import Foundation
import Models
import Dependencies
import Utilities

// MARK: - Stored variables
extension SelectCategoryScreen {
    
    @Observable
    final class ViewModel {
        
        var searchText: String = ""
        
        @ObservationIgnored
        @Dependency(\.categoryStore) var categoryStore
    }
    
}

// MARK: - Computed variables
extension SelectCategoryScreen.ViewModel {
    
    var categoriesFiltered: [CategoryModel] {
        let categories = categoryStore.categories
        
        guard let income = categories.filter({ $0.isIncome }).first else { return [] }
        guard let toCategorized = categories.filter({ $0.isToCategorized }).first else { return [] }
        let allCategories = [toCategorized, income] + categories
            .filter { !$0.isIncome && !$0.isToCategorized }
            .sorted { $0.name < $1.name }
        
        if searchText.isEmpty {
            return allCategories
        } else { // Searching
            let filteredCategories = allCategories
                .filter {
                    $0.name.localizedStandardContains(searchText)
                    || (($0.subcategories ?? []).contains { $0.name.localizedStandardContains(searchText) })
                }
            
            return filteredCategories
        }
    }
    
}

// MARK: - Public functions
extension SelectCategoryScreen.ViewModel {
    
    func subcategoriesFiltered(for category: CategoryModel) -> [SubcategoryModel] {
        guard let subcategories = category.subcategories else { return [] }
        if searchText.isEmpty {
            return subcategories
                .sorted { $0.name > $1.name }
        } else {
            return subcategories
                .sorted { lhs, rhs in
                    return lhs.name.levenshteinDistanceScore(to: searchText) > rhs.name.levenshteinDistanceScore(to: searchText)
                }
        }
    }
    
}
