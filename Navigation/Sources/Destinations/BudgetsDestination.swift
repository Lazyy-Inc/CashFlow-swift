//
//  BudgetsDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import NavigationKit
import Models

public enum BudgetsDestination: DestinationItem {
    case list
    case create
    case transactions(subcategory: SubcategoryModel)
}
