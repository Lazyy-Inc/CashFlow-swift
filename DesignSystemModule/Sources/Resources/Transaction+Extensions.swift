//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import CoreModule
import SwiftUI
import TheoKit

extension TransactionModel {
    
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
    
}
