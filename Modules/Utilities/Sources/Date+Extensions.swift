//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation

public extension Date {
    var oneMonthAgo: Date {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)!
    }
}
