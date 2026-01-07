//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Core
import SwiftUI
import Models

public extension TransactionModel {
    
    var color: Color {
        switch type {
        case .expense:
            return Color.Red.red500
        case .income:
            return .primary500
        case .transfer:
            return isSender ? Color.Red.red500 : .primary500
        }
    }
    
    var categoryColor: Color {
        return self.category?.color ?? .red
    }
    
}
