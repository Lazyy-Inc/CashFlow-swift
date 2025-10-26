//
//  CreateSubscriptionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 02/11/2023.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores
import Events
import Dependencies

// MARK: - Stored variables
extension AddSubscriptionScreen {
    
    @Observable
    final class ViewModel: AddViewModel {
    
        var subscription: SubscriptionModel?
        
        var name: String = ""
        var amount: String = ""
        var frequencyDate: Date = .now
        var frequency: SubscriptionFrequency = .monthly
        var selectedCategory: CategoryModel?
        var selectedSubcategory: SubcategoryModel?
        
        var isAlertLeavePresented: Bool = false
        
        let successfullModalManager: SuccessfullModalManager = .shared

        var isEditing: Bool { return subscription != nil }
        
        var namePlaceholder: String = ""
        var amountPlaceholder: String = ""
        
        @ObservationIgnored
        @Dependency(\.accountStore) var accountStore
        
        @ObservationIgnored
        @Dependency(\.subscriptionStore) private var subscriptionStore
        
        init(subscription: SubscriptionModel? = nil) {
            self.subscription = subscription
            if let subscription {
                self.name = subscription.name
                self.amount = subscription.amount.formatted()
                self.frequency = subscription.frequency
                self.frequencyDate = subscription.frequencyDate
                self.selectedCategory = subscription.category
                self.selectedSubcategory = subscription.subcategory
            }
            
            randomNamePlaceholder()
            randomAmountPlaceholder()
        }
    }
    
}

// MARK: - Computed variables
extension AddSubscriptionScreen.ViewModel {
    
    var navigationTitle: String {
        return subscription == nil ? Word.Title.Subscription.new : Word.Title.Subscription.update
    }
    
    var actionButtonTitle: String {
        return subscription == nil ? Word.Classic.create : Word.Classic.edit
    }
    
    var isModelInCreation: Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !name.isBlank || amount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        if !name.isBlank && amount.toDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
    
}

// MARK: - Public functions
extension AddSubscriptionScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        VibrationManager.vibration()
        if subscription != nil {
            await updateSubscription(dismiss: dismiss)
        } else {
            await createNewSubscription(dismiss: dismiss)
        }
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            if isEditing {
                EventService.sendEvent(key: EventKeys.subscriptionUpdateCanceled)
            } else {
                EventService.sendEvent(key: EventKeys.subscriptionCreationCanceled)
            }
            dismiss()
        }
    }
    
}

extension AddSubscriptionScreen.ViewModel {
    
    private func bodyForCreation() -> SubscriptionDTO {
        return .init(
            name: name,
            amount: amount.toDouble(),
            type: selectedCategory?.isIncome == true ? TransactionType.income : TransactionType.expense,
            frequency: frequency,
            frequencyDate: frequencyDate.toISO(),
            categoryID: selectedCategory?.id ?? 0,
            subcategoryID: selectedSubcategory?.id
        )
    }
    
    private func createNewSubscription(dismiss: DismissAction) async {        
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        
        if let newSubscritpion = await subscriptionStore.createSubscription(
            accountID: accountID,
            body: bodyForCreation(),
            shouldReturn: true
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulSubscription(
                type: .new,
                subscription: newSubscritpion
            )
        }
    }
    
    private func updateSubscription(dismiss: DismissAction) async {
        if let subscription {
            if let updatedSubscription = await subscriptionStore.updateSubscription(
                subscriptionID: subscription.id,
                body: bodyForCreation()
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulSubscription(
                    type: .update,
                    subscription: updatedSubscription
                )
            }
        }
    }
    
}

// MARK: - Private functions UI
extension AddSubscriptionScreen.ViewModel {
    
    private func randomNamePlaceholder() {
        let placeholdersAvailable: [String] = [
            "create_subscription_field_name_placeholder_one",
            "create_subscription_field_name_placeholder_two",
            "create_subscription_field_name_placeholder_three",
            "create_subscription_field_name_placeholder_four",
            "create_subscription_field_name_placeholder_five",
            "create_subscription_field_name_placeholder_six",
            "create_subscription_field_name_placeholder_seven",
            "create_subscription_field_name_placeholder_eight",
            "create_subscription_field_name_placeholder_nine",
            "create_subscription_field_name_placeholder_ten"
        ]
        
        self.namePlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
    private func randomAmountPlaceholder() {
        self.amountPlaceholder = Double.random(in: 2.0...30.0).toString()
    }
    
}
