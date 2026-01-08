//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 07/01/2026.
//

import Foundation
import SwiftUI
import Models

public extension RoundedBackgroundType {
    
    var color: Color {
        switch self {
        case .classic:
            return Color.Background.bg100
        case .field:
            return Color.Background.bg100
        case .custom(let color, _, _, _):
            return color
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .classic:
            return .mediumLarge
        case .field:
            return .medium
        case .custom(_, let radius, _, _):
            return radius
        }
    }
    
    var strokeColor: Color? {
        switch self {
        case .classic:
            return Color.Background.bg200
        case .field:
            return Color.Background.bg200
        case .custom(_, _, _, let strokeColor):
            return strokeColor
        }
    }
    
    var lineWidth: CGFloat {
        switch self {
        case .classic:
            return 1
        case .field:
            return 1
        case .custom(_, _, let lineWidth, _):
            return lineWidth
        }
    }
    
}
