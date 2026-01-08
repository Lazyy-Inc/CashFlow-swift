//
//  CreateContributionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/11/2024.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores
import Events

extension AddContributionScreen {
    
    @Observable
    final class ViewModel: AddViewModel {
        
        // MARK: Dependencies
        var savingsPlan: SavingsPlanModel
        
        var name: String = ""
        var amount: String = ""
        var type: ContributionType = .addition
        var date: Date = Date()
        
        var isAlertLeavePresented: Bool = false
        
        init(savingsPlan: SavingsPlanModel) {
            self.savingsPlan = savingsPlan
        }
    }
    
}

extension AddContributionScreen.ViewModel {
    
    var navigationTitle: String {
        return "create_contribution_title".localized
    }
    
    var actionButtonTitle: String {
        return "create_contribution_validation_button".localized
    }
    
    var isModelInCreation: Bool {
        if amount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        guard amount.toDouble() != 0 else { return false }
        if type == .withdrawal && ((savingsPlan.currentAmount ?? 0) - amount.toDouble() < 0) {
            return false
        }
        return true
    }
    
    var valueAfterContribution: Double {
        let currentAmount = savingsPlan.currentAmount ?? 0
       
        if type == .addition {
            return currentAmount + amount.toDouble()
        } else {
            return currentAmount - amount.toDouble()
        }        
    }
    
}

extension AddContributionScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        await createContribution(dismiss: dismiss)
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            // EventService.sendEvent(key: EventKeys.contributionCreationCanceled)
            dismiss()
        }
    }
    
    func createContribution(dismiss: DismissAction) async {
        guard let savingsPlanID = savingsPlan.id else { return }
        let contributionStore: ContributionStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        if let contribution = await contributionStore.createContribution(
            savingsplanID: savingsPlanID,
            body: .init(
                name: name.isEmpty ? nil : name,
                amount: amount.toDouble(),
                typeNum: type.rawValue,
                dateString: date.toISO()
            )
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulContribution(
                type: .new,
                savingsPlan: savingsPlan,
                contribution: contribution
            )
        }
    }
    
}
