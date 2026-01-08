//
//  CreateSavingsPlanViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/11/2023.
//

import Foundation
import SwiftUI
import Core
import Dependencies
import Models
import Stores
import Events

extension AddFinancialGoalScreen {
    
    @Observable
    final class ViewModel: AddViewModel {
        
        var savingsPlan: SavingsPlanModel?
        
        var name: String = ""
        var emoji: String = "💻"
        var savingPlanAmountOfStart: String = ""
        var goalAmount: String = ""
        var startDate: Date = .now
        var endDate: Date = .now
        
        var isEndDate: Bool = false
        var showEmojiPicker: Bool = false
        
        var namePlaceholder: String = ""
        var goalAmountPlaceholder: String = ""
        
        var isAlertLeavePresented: Bool = false
        
        var isEditing: Bool { return savingsPlan != nil }
        
        let successfullModalManager: SuccessfullModalManager = .shared
        
        @ObservationIgnored
        @Dependency(\.savingsPlanStore) var savingsPlanStore
        
        init(savingsPlan: SavingsPlanModel? = nil) {
            if let savingsPlan {
                self.savingsPlan = savingsPlan
                self.name = savingsPlan.name ?? ""
                self.emoji = savingsPlan.emoji ?? "💻"
                self.goalAmount = savingsPlan.goalAmount?.toString(maxDigits: 0) ?? ""
                self.startDate = savingsPlan.startDate
                self.endDate = savingsPlan.endDate ?? .now
                self.isEndDate = savingsPlan.endDateString != nil
            }
            
            randomNamePlaceholder()
            randomGoalAmountPlaceholder()
        }
        
    }
    
}

// MARK: - Computed variables
extension AddFinancialGoalScreen.ViewModel {
    
    var navigationTitle: String {
        return savingsPlan == nil ? Word.Title.SavingsPlan.new : Word.Title.SavingsPlan.update
    }
    
    var actionButtonTitle: String {
        return savingsPlan == nil ? "create_financial_validation_button" : "edit_financial_validation_button"
    }
            
    var isModelInCreation: Bool {
        if !name.isBlank || savingPlanAmountOfStart.toDouble() != 0 || goalAmount.toDouble() != 0 || isEndDate {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        if !goalAmount.isEmpty && !name.isBlank && !emoji.isBlank {
            return true
        }
        return false
    }
    
}

// MARK: Public functions
extension AddFinancialGoalScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        VibrationManager.vibration()
        if savingsPlan == nil {
            await createSavingsPlan(dismiss: dismiss)
        } else {
            await updateSavingsPlan(dismiss: dismiss)
        }
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            if isEditing {
                // EventService.sendEvent(key: EventKeys.savingsplanUpdateCanceled)
            } else {
                // EventService.sendEvent(key: EventKeys.savingsplanCreationCanceled)
            }
            dismiss()
        }
    }
    
}

// MARK: - Private functions
extension AddFinancialGoalScreen.ViewModel {
    
    private func bodyForCreation() -> SavingsPlanModel {
        return SavingsPlanModel(
            name: name,
            emoji: emoji,
            startDateString: startDate.toISO(),
            endDateString: isEndDate ? endDate.toISO() : nil,
            goalAmount: goalAmount.toDouble()
        )
    }
    
    private func createSavingsPlan(dismiss: DismissAction) async {
        @Dependency(\.contributionStore) var contributionStore
        
        if let savingsPlan = await savingsPlanStore.createSavingsPlan(body: bodyForCreation()) {
            if let savingsPlanID = savingsPlan.id, savingPlanAmountOfStart.toDouble() != 0 {
                await contributionStore.createContribution(
                    savingsplanID: savingsPlanID,
                    body: .init(
                        amount: savingPlanAmountOfStart.toDouble(),
                        typeNum: ContributionType.addition.rawValue,
                        dateString: startDate.toISO())
                )
            }
            
            await dismiss()
            await successfullModalManager.showSuccessfulSavingsPlan(type: .new, savingsPlan: savingsPlan)
        }
    }
    
    private func updateSavingsPlan(dismiss: DismissAction) async {
        guard let savingsPlan else { return }
        guard let savingsPlanID = savingsPlan.id else { return }
        
        await savingsPlanStore.updateSavingsPlan(
            savingsPlanID: savingsPlanID,
            body: bodyForCreation()
        )
        
        await dismiss()
        await successfullModalManager.showSuccessfulSavingsPlan(type: .update, savingsPlan: savingsPlan)
    }
    
    private func randomNamePlaceholder() {
        let placeholdersAvailable: [String] = [
            "create_financial_goal_field_name_placeholder_one",
            "create_financial_goal_field_name_placeholder_two",
            "create_financial_goal_field_name_placeholder_three",
            "create_financial_goal_field_name_placeholder_four",
            "create_financial_goal_field_name_placeholder_five"
        ]
        
        self.namePlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
    private func randomGoalAmountPlaceholder() {
        let placeholdersAvailables: [Int] = [
            1000, 2000, 5000, 10000, 30000
        ]
        
        self.goalAmountPlaceholder = placeholdersAvailables.randomElement()?.formatted() ?? ""
    }
    
}
