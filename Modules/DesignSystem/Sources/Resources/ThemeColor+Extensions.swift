//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import SwiftUI
import Core

extension ThemeColor {
    
    public var color: Color {
        switch self {
        case .green: return .primary500
        case .blue: return .blue
        case .purple: return .purple
        case .red: return .red
        }
    }
    
}
