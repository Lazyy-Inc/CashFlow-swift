//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 06/10/2025.
//

import Foundation

public struct PeriodDateModel: Sendable {
    public var startDate: Date
    public var endDate: Date
    
    public init(startDate: Date, endDate: Date) {
        self.startDate = startDate
        self.endDate = endDate
    }
}

public extension PeriodDateModel {
    
    static let mock: PeriodDateModel = .init(
        startDate: .now,
        endDate: Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
    )
    
}
