//
//  CategoryMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import Models
import SwiftUI

public extension CategoryModel {
    static let mock = CategoryModel(
        id: 1,
        name: "category1_name",
        icon: "iconCart",
        color: Color.red,
        subcategories: [
            SubcategoryModel.mock
        ]
    )
}
