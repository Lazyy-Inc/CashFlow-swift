//
//  CategoryDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUI
import NavigationKit
import Models

public enum CategoryDestination: DestinationItem {
    case list
    case transactions(category: CategoryModel, selectedDate: Date)
    case select(selectedCategory: Binding<CategoryModel?>, selectedSubcategory: Binding<SubcategoryModel?>)
}
