//
//  SubcategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

public struct SubcategoryModel: Identifiable, Equatable, Hashable, Sendable {
    public var id: Int
    public var name: String
    public var icon: String
    public var color: Color
    public var isVisible: Bool
    
    public init(id: Int, name: String, icon: String, color: Color, isVisible: Bool) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.isVisible = isVisible
    }
}

public extension SubcategoryModel {
    static let mock = SubcategoryModel(
        id: 1,
        name: "category1_subcategory1_name".localized,
        icon: "iconDumbbell",
        color: .red,
        isVisible: true
    )
}
