//
//  SuccessfullModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import SwiftUI
import CoreModule

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulTransfer(type: SuccessfulType, transfer: TransactionModel) {
        self.title = Word.Successful.Transfer.title(type: type)
        self.subtitle = Word.Successful.Transfer.description(type: type)
        self.content = AnyView(TransferRowView(transfer: transfer, location: .successfulSheet).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
    @MainActor
    func showSuccessfulContribution(type: SuccessfulType, savingsPlan: SavingsPlanModel, contribution: ContributionModel) {
        self.title = Word.Successful.Contribution.title(type: type)
        self.subtitle = Word.Successful.Contribution.description(type: type)
        self.content = AnyView(ContributionRowView(savingsPlan: savingsPlan, contribution: contribution))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
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

extension SuccessfullModalManager {
    
    func resetData() {
        self.title = ""
        self.subtitle = ""
        self.content = EmptyView()
    }
    
}
