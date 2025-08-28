//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models
import CoreModule

public extension SubscriptionFrequency {
  var name: String {
      switch self {
      case .monthly: return Word.Frequency.monthly
      case .yearly: return Word.Frequency.yearly
      case .weekly: return Word.Frequency.weekly
      }
  }
}
