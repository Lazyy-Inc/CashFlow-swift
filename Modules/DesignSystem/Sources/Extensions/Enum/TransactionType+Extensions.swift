//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models
import Core
import SwiftUI
import TheoKit

public extension FinancialItemType {
  
    var name: String {
        switch self {
        case .expense:
            return Word.Classic.expense
        case .income:
            return Word.Classic.income
        case .transfer:
            return Word.Main.transfer
        }
    }
    
    func color(isSender: Bool = false) -> Color {
        switch self {
        case .expense:
            return TKDesignSystem.Colors.Error.c500
        case .income:
            return .primary500
        case .transfer:
            return isSender ? TKDesignSystem.Colors.Error.c500 : .primary500
        }
    }
    
}
