//
//  CategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

public struct CategoryModel: Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var icon: String
    public var color: Color
    public var subcategories: [SubcategoryModel]?
    
    public init(id: Int, name: String, icon: String, color: Color, subcategories: [SubcategoryModel]? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.subcategories = subcategories
    }
}

public extension CategoryModel {
    
    var isIncome: Bool {
        return self.name == "word_income".localized
    }
    
    var isToCategorized: Bool {
        return self.name == "category00_name".localized
    }
    
}

extension CategoryModel: Searchable {
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
