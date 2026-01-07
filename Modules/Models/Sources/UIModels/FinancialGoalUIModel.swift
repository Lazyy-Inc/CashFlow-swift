//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 07/01/2026.
//

import Foundation

public struct FinancialGoalUIModel: UIModel {
    public var id: Int
    public var name: String
    public var emoji: String
    public var startDate: Date
    public var endDate: Date?
    public var currentAmount: Double
    public var goalAmount: Double
    public var isArchived: Bool
    
    // MARK: Init
    public init(
        id: Int,
        name: String,
        emoji: String,
        startDate: Date,
        endDate: Date? = nil,
        currentAmount: Double,
        goalAmount: Double,
        isArchived: Bool
    ) {
        self.id = id
        self.name = name
        self.emoji = emoji
        self.startDate = startDate
        self.endDate = endDate
        self.currentAmount = currentAmount
        self.goalAmount = goalAmount
        self.isArchived = isArchived
    }
}

extension FinancialGoalUIModel: Searchable {
    public var searchableText: String { name }
}

public extension FinancialGoalUIModel {
    var hasAnEndDate: Bool { endDate != nil }
}
