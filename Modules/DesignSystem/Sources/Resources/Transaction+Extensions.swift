//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Core
import SwiftUI
import TheoKit
import Models

public extension TransactionModel { // TODO: Can be removed ?
    
    var color: Color {
        switch type {
        case .expense:
            return TKDesignSystem.Colors.Error.c500
        case .income:
            return .primary500
        case .transfer:
            return isSender ? TKDesignSystem.Colors.Error.c500 : .primary500
        }
    }
    
    var categoryColor: Color {
        return self.category?.color ?? .red
    }
    
}
