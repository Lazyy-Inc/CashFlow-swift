//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 16/01/2026.
//

import Foundation
import SwiftUI

public struct CategoryChartUIModel: Hashable {
    private let category: CategoryModel
    private let transactions: [TransactionModel]
    
    public init(
        category: CategoryModel,
        transactions: [TransactionModel]
    ) {
        self.category = category
        self.transactions = transactions
    }
}

public extension CategoryChartUIModel {
    
    var amount: Double {
        transactions
            .map(\.amount)
            .reduce(0, +)
    }
    
    var color: Color {
        category.color
    }
    
    var categoryName: String {
        return category.name
    }
    
}

// MARK: - Mocks
public extension CategoryChartUIModel {
    
    @MainActor
    static let mock: CategoryChartUIModel = .init(
        category: .mock,
        transactions: [
            .mockClassicTransaction,
            .mockClassicTransaction2
        ]
    )
    
}
