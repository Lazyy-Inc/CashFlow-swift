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
    
}
