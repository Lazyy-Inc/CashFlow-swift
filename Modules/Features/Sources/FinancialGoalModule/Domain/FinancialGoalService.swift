//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 07/01/2026.
//

import Foundation
import Models
import Dependencies
import Stores

protocol FinancialGoalService {
    func remainingAmount(for goal: SavingsPlanModel) -> Double
    func monthlyTarget(for goal: SavingsPlanModel) -> Double
    func recalculatedMonthlyTarget(for goal: SavingsPlanModel) -> Double
    func contributionsAmount(for period: PeriodType) -> Double
}

final class DefaultFinancialGoalService: FinancialGoalService {
    
}

// MARK: - Monthly
extension FinancialGoalService {
    
    func remainingAmount(for goal: SavingsPlanModel) -> Double {
        guard let goalAmount = goal.goalAmount else { return 0 }
        return max(0, goalAmount - (goal.currentAmount ?? 0))
    }
    
    func monthlyTarget(for goal: SavingsPlanModel) -> Double {
        guard let goalAmount = goal.goalAmount, let endDate = goal.endDate else { return 0 }
        
        let monthsBetween = goal.startDate.monthsBetween(endDate)
        return goalAmount / Double(monthsBetween)
    }
    
    func recalculatedMonthlyTarget(for goal: SavingsPlanModel) -> Double {
        guard let endDate = goal.endDate else { return 0 }
        let monthsBetween = Date.now.monthsBetween(endDate)
        return remainingAmount(for: goal) / Double(monthsBetween)
    }
    
    func contributionsAmount(for period: PeriodType) -> Double {
        @Dependency(\.contributionStore) var contributionStore
        switch period {
        case .currentMonth:
            return contributionStore.getAmountOfContributions(in: .now)
        case .total:
            return contributionStore.getAmountOfContributions()
        default:
            return 0
        }
    }
    
}
