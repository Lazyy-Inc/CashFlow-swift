//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 17/08/2025.
//

import Foundation
import CoreModule
import SwiftUI

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfullBudget(type: SuccessfulType, budget: BudgetModel) {
        self.title = "budget_successful".localized
        self.subtitle = "budget_successful_desc".localized
        self.content = AnyView(BudgetRowView(budget: budget))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
