//
//  SubcategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SubcategoryDestination: DestinationItem {
    case list(category: CategoryModel, selectedDate: Date)
    case transactions(subcategory: SubcategoryModel, selectedDate: Date)
}
