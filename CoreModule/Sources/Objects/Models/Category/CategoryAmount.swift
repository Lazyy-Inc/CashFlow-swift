//
//  CategoryAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/05/2025.
//

import Foundation

public struct CategoryAmount: Identifiable {
    public let id: UUID
    public let categoryId: Int?
    public let amount: Double
    
    public init(categoryId: Int?, amount: Double) {
        self.id = UUID()
        self.categoryId = categoryId
        self.amount = amount
    }
}
