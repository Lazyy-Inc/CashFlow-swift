//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 07/01/2026.
//

import Foundation

public struct FinancialGoalAPIModel: APIModel {
    public var id: Int?
    public var name: String?
    public var emoji: String?
    public var startDate: String?
    public var endDate: String?
    public var currentAmount: Double?
    public var goalAmount: Double?
    public var isArchived: Bool?
    
    // MARK: Init
    public init(
        id: Int? = nil,
        name: String? = nil,
        emoji: String? = nil,
        startDate: String? = nil,
        endDate: String? = nil,
        currentAmount: Double? = nil,
        goalAmount: Double? = nil,
        isArchived: Bool? = nil
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

public extension FinancialGoalAPIModel {
    
    static func body(
        name: String,
        emoji: String,
        startDate: String,
        endDate: String? = nil,
        currentAmount: Double,
        goalAmount: Double
    ) -> FinancialGoalAPIModel {
        return .init(
            name: name,
            emoji: emoji,
            startDate: startDate,
            endDate: endDate,
            currentAmount: currentAmount,
            goalAmount: goalAmount
        )
    }
    
}
