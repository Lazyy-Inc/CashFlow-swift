//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 21/01/2026.
//

import Foundation
import Models
import SwiftUI

public extension RepartitionType {
    
    var color: Color {
        switch self {
        case .notDefined:
            Color.clear
        case .needed:
            Color.Category.categoryHealth
        case .wanted:
            Color.Category.categoryLeisure
        case .saved:
            Color.Category.categorySavings
        }
    }
    
}
