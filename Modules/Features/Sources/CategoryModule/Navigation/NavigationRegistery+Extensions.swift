//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 21/01/2026.
//

import Foundation
import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerCategoryRoutes() {
        self.register(CategoryDestination.self) { destination in
            switch destination {
            case .list:
                AnyView(CategoriesListScreen())
            case .transactions(let category, let selectedDate):
                AnyView(CategoryTransactionsScreen(category: category, selectedDate: selectedDate))
            case .select(let selectedCategory, let selectedSubcategory):
                AnyView(SelectCategoryScreen(selectedCategory: selectedCategory, selectedSubcategory: selectedSubcategory))
            }
        }
    }
    
}



