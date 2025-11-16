//
//  AlertManager+Extensions.swift
//  DesignSystem
//
//  Created by Theo Sementa on 16/11/2025.
//

import Foundation
import AlertKit
import SwiftUI
import Core
import Models
import Stores

public extension AlertManager {
    
    func deleteTransaction(transaction: TransactionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_transaction_delete_title".localized,
            message: transaction.type == .expense
            ? "alert_transaction_expense_message".localized
            : "alert_transaction_income_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                await TransactionStore.shared.deleteTransaction(transactionId: transaction.id)
                if let dismissAction { dismissAction() }
            }
        )
    }
    
    func deleteTransfer(transfer: TransactionModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_transfer_delete_title".localized,
            message: "alert_transfer_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                await TransferStore.shared.deleteTransfer(transferID: transfer.id)
                if let dismissAction { dismissAction() }
            }
        )
    }
    
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
