//
//  File.swift
//  Mocks
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models

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
