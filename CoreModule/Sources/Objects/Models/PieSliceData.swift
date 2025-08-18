//
//  PieSliceData.swift
//  CustomPieChart
//
//  Created by KaayZenn on 10/08/2024.
//

import Foundation
import SwiftUI

public struct PieSliceData: Hashable {
    public var categoryID: Int
    public var subcategoryID: Int?
    public var icon: String
    public var value: Double
    public var color: Color
    
    public init(categoryID: Int, subcategoryID: Int? = nil, icon: String, value: Double, color: Color) {
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.icon = icon
        self.value = value
        self.color = color
    }
}
