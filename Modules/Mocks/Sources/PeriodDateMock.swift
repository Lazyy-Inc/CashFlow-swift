//
//  File.swift
//  Mocks
//
//  Created by Theo Sementa on 06/10/2025.
//

import Foundation
import Models

public extension PeriodDateModel {
  
  static let mock: PeriodDateModel = .init(
    startDate: .now,
    endDate: Calendar.current.date(byAdding: .month, value: 1, to: .now) ?? .now
  )
  
}
