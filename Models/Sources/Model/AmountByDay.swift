//
//  AmountByDay.swift
//  CashFlow
//
//  Created by Theo Sementa on 25/07/2023.
//

import Foundation

public struct AmountByDay: Hashable, Identifiable {
    public let id: UUID = UUID()
    public var day: Date
    public var amount: Double
    
    public init(day: Date, amount: Double) {
        self.day = day
        self.amount = amount
    }
}
