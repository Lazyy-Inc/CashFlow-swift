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
  public var month: Date?
  public var type: FinancialItemType?
  
  public init(
    category: CategoryModel? = nil,
    subcategory: SubcategoryModel? = nil,
    month: Date? = nil,
    type: FinancialItemType? = nil
  ) {
    self.category = category
    self.subcategory = subcategory
    self.month = month
    self.type = type
  }
}
