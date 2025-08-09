//
//  CategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

public enum CategoryDestination: DestinationItem {
    case list
    case transactions(category: CategoryModel, selectedDate: Date)
    case select(selectedCategory: Binding<CategoryModel?>, selectedSubcategory: Binding<SubcategoryModel?>)
}
