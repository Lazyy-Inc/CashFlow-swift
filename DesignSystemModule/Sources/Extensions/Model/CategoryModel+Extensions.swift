//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models
import Core
import Stores

extension CategoryModel: @retroactive Searchable {
    public var searchableText: String {
        let subcategoryNames = subcategories?.map { $0.name } ?? []
        return "\(name) \(subcategoryNames.joined(separator: " "))"
    }
}

public extension CategoryModel {
    
    static var revenue: CategoryModel? {
        return CategoryStore.shared.findCategoryById(1)
    }
    
    static var toCategorized: CategoryModel? {
        return CategoryStore.shared.findCategoryById(0)
    }
    
}
