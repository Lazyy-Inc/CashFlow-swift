//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models

public extension SavingsPlanModel {
  
  var daysSinceStart: Int {
      return max(0, startDate.daysSince())
  }
  
  var daysRemaining: Int {
      guard let endDate else { return 0 }
      return max(0, endDate.daysTo())
  }
  
  var amountToTheGoal: Double {
      guard let goalAmount else { return 0 }
      return max(0, goalAmount - (currentAmount ?? 0))
  }
  
  var monthlyGoalAmount: Double {
      guard let goalAmount, let endDate else { return 0 }
      let monthsBetween = startDate.monthsBetween(endDate)
      return goalAmount / Double(monthsBetween)
  }
  
  var percentageComplete: Double {
      guard let goalAmount, let currentAmount else { return 0 }
      return currentAmount / goalAmount
  }
  
}
