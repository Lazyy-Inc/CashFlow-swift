//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import SwiftUI
import AlertKit
import CoreModule

public extension AlertManager {
    
    func deleteSubscription(subscription: SubscriptionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_subscription_delete_title".localized,
            message: "alert_subscription_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                await SubscriptionStore.shared.deleteSubscription(subscriptionID: subscription.id)
                if let dismissAction { dismissAction() }
            }
        )
    }
    
}
