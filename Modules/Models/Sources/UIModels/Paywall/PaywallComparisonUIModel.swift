//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 08/01/2026.
//

import Foundation

public struct PaywallComparisonUIModel: UIModel {
    public let id: UUID = UUID()
    public let title: String
    public let free: Int? // 0 = true, X = displayValue, nil = -
    public let max: Int? // 0 = true, X = displayValue, nil = -
    
    public init(
        title: String,
        free: Int?,
        max: Int?
    ) {
        self.title = title
        self.free = free
        self.max = max
    }
}

// MARK: - Mocks
public extension PaywallComparisonUIModel {
    
    @MainActor
    static let mock1: PaywallComparisonUIModel = .init(
        title: "Comptes bancaires illimités",
        free: 1,
        max: 0
    )
    
    @MainActor
    static let mock2: PaywallComparisonUIModel = .init(
        title: "Comptes bancaires illimités",
        free: nil,
        max: 0
    )
    
}
