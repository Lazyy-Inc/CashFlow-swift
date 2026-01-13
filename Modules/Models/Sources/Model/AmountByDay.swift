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

@MainActor
public extension AmountByDay {
    static let mockToday = AmountByDay(
        day: Date(),
        amount: 150.0
    )
    
    static let mockTomorrow = AmountByDay(
        day: Calendar.current.date(byAdding: .day, value: 1, to: Date())!,
        amount: 200.5
    )
    
    static let mockYesterday = AmountByDay(
        day: Calendar.current.date(byAdding: .day, value: -1, to: Date())!,
        amount: 75.3
    )
    
    static let mockAll: [AmountByDay] = [
        .mockYesterday,
        .mockToday,
        .mockTomorrow
    ]
}
