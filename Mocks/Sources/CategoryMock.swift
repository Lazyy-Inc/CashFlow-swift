//
//  CategoryMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import Models
import SwiftUI
import TheoKit

public extension CategoryModel {
    static let mock = CategoryModel(
        id: 1,
        name: "category1_name".localized,
        icon: "iconCart",
        color: Color.red,
        subcategories: [
            SubcategoryModel.mock
        ]
    )
}
