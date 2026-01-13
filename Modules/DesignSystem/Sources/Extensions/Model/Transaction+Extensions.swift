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
            return Color.Red.r500
        case .income:
            return Color.Primary.p500
        case .transfer:
            return isSender ? Color.Red.r500 : Color.Primary.p500
        }
    }
    
    var categoryColor: Color {
        return self.category?.color ?? .red
    }
    
}
