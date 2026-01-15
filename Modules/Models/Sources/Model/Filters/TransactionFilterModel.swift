//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 07/10/2025.
//

import Foundation

public struct TransactionFilterModel {
    public var category: CategoryModel?
    public var subcategory: SubcategoryModel?
    public var type: FinancialItemType?
    public var isFromSubscription: Bool?
    public var month: Date?
    
    public init(
        category: CategoryModel? = nil,
        subcategory: SubcategoryModel? = nil,
        type: FinancialItemType? = nil,
        isFromSubscription: Bool? = nil,
        month: Date? = nil
    ) {
        self.category = category
        self.subcategory = subcategory
        self.type = type
        self.isFromSubscription = isFromSubscription
        self.month = month
    }
}
