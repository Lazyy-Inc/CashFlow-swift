//
//  NavigationRegistery+SubcategoryDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerSubcategoryRoutes() {
        self.register(SubcategoryDestination.self) { destination in
            switch destination {
            case .list(let category, let selectedDate):
                AnyView(SubcategoryListScreen(category: category, selectedDate: selectedDate))
            case .transactions(let subcategory, let selectedDate):
                AnyView(SubcategoryTransactionsScreen(subcategory: subcategory, selectedDate: selectedDate))
            }
        }
    }
    
}
