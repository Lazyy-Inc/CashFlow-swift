//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Core
import SwiftUI
import Models
import DesignSystem

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulSubscription(type: SuccessfulType, subscription: SubscriptionModel) {
        self.title = Word.Successful.Subscription.title(type: type)
        self.subtitle = Word.Successful.Subscription.description(type: type)
        self.content = AnyView(FinancialItemRowView(financialItem: subscription, isEditable: false).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
