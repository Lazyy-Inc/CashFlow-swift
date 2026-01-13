//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 07/01/2026.
//

import Foundation
import Stores
import Models
import Core

extension FinancialGoalDetailsScreen {
    
    @Observable
    final class ViewModel {
        
        // MARK: Dependencies
        let financialGoalId: Int
        let financialGoalService: FinancialGoalService
        
        @ObservationIgnored
        @Dependency(\.savingsPlanStore) private var savingsPlanStore
        
        @ObservationIgnored
        @Dependency(\.contributionStore) var contributionStore
            
        var selectedDate: Date = Date()
        var selectedYear: Int = Date().year
        var contributionsByMonth: [Double] = []
        var amountOfSelectedMonth: Double = 0
        
        // MARK: Init
        public init(
            financialGoalId: Int,
            financialGoalService: FinancialGoalService = DefaultFinancialGoalService()
        ) {
            self.financialGoalId = financialGoalId
            self.financialGoalService = financialGoalService
        }
    }
    
}

// MARK: - Computed variables
extension FinancialGoalDetailsScreen.ViewModel {
    
    var financialGoal: SavingsPlanModel? {
        return savingsPlanStore.savingsPlans.first { $0.id == financialGoalId }
    }
    
}

// MARK: - UI Variables
extension FinancialGoalDetailsScreen.ViewModel {
    
    var remainingAmount: Double {
        guard let financialGoal else { return 0 }
        return financialGoalService.remainingAmount(for: financialGoal)
    }
    
    var monthlyTarget: Double {
        guard let financialGoal else { return 0 }
        return financialGoalService.monthlyTarget(for: financialGoal)
    }
    
    var recalculatedMonthlyTarget: Double {
        guard let financialGoal else { return 0 }
        return financialGoalService.recalculatedMonthlyTarget(for: financialGoal)
    }
    
    var contributionsAmount: Double {
        return financialGoalService.contributionsAmount(for: .total)
    }
    
    var contributionsAmountForCurrentMonth: Double {
        return financialGoalService.contributionsAmount(for: .currentMonth)
    }
    
}

// MARK: - Public methods
extension FinancialGoalDetailsScreen.ViewModel {
    
    func onChangeSelectedDate() {
        if selectedDate.year != selectedYear {
            selectedYear = selectedDate.year
            contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
        }
        amountOfSelectedMonth = contributionsByMonth[selectedDate.month - 1]
    }
    
    func onChangeContributionsCount() {
        contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
        amountOfSelectedMonth = contributionsByMonth[selectedDate.month - 1]
    }
    
    func onChartAppear() {
        contributionsByMonth = contributionStore.getContributionsAmountByMonth(for: selectedDate.year)
        amountOfSelectedMonth = contributionsByMonth[selectedDate.month - 1]
    }
    
}
