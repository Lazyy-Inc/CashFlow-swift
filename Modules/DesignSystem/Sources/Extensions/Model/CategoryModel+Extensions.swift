//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models
import Core
import Stores
import Dependencies

extension CategoryModel: @retroactive Searchable {
    public var searchableText: String {
        let subcategoryNames = subcategories?.map { $0.name } ?? []
        return "\(name) \(subcategoryNames.joined(separator: " "))"
    }
}

public extension CategoryModel {
    
    static var revenue: CategoryModel? {
        @Dependency(\.categoryStore) var categoryStore
        return categoryStore.findCategoryById(1)
    }
    
    static var toCategorized: CategoryModel? {
        @Dependency(\.categoryStore) var categoryStore
        return categoryStore.findCategoryById(0)
    }
    
}
