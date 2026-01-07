//
//  BudgetStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import Core
import SwiftUI
import Events
import Models
import Stores
import Networking
import Dependencies

public extension BudgetStore {
    
    var budgetsByCategory: [CategoryModel: [BudgetModel]] {
        let groupedBySubcategory = Dictionary(grouping: budgets) { $0.category }
        return groupedBySubcategory
            .compactMap { entry -> (key: CategoryModel, value: [BudgetModel])? in
                guard let key = entry.key else { return nil }
                return (key: key, value: entry.value)
            }
            .sorted(by: { $0.key.name < $1.key.name })
            .reduce(into: [CategoryModel: [BudgetModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
}

public extension BudgetModel {
    
    var category: CategoryModel? {
        @Dependency(\.categoryStore) var categoryStore
        return categoryStore.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        @Dependency(\.categoryStore) var categoryStore
        return categoryStore.findSubcategoryById(subcategoryID)
    }
    
    var name: String {
        if let subcategory {
            return subcategory.name
        } else if let category {
            return category.name
        } else {
            return ""
        }
    }
    
    var color: Color {
        return category?.color ?? .gray
    }
    
    var currentAmount: Double {
        guard let subcategory else { return 0 }

        var amount: Double = 0.0
        
        for transaction in subcategory.transactions where transaction.category != nil {
            let subcategoryOfTransaction = transaction.subcategory
            
            if transaction.type == .expense
                && subcategoryOfTransaction == subcategory
                && Calendar.current.isDate(transaction.date, equalTo: Date(), toGranularity: .month) {
                amount += transaction.amount
            }
        }
        
        return amount
    }
    
    var isExceeded: Bool {
        return currentAmount > amount
    }
    
}
