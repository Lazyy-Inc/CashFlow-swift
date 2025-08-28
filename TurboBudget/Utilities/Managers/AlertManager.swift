//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//  Localized with Toglee on 14/04/2025

import Foundation
import AlertKit
import SwiftUI
import Navigation
import Core
import Events
import Models
import Stores

extension AlertManager {
    
    func showPaywall(router: Router<AppDestination>) {
        self.present(
            title: "alert_cashflow_pro_title".localized,
            message: "alert_cashflow_pro_desc".localized,
            buttonTitle: "alert_cashflow_pro_action_button".localized,
            isDestructive: false,
            action: {
                router.present(route: .fullScreenCover, .shared(.paywall))
            }
        )
    }

    func onlyOneCreditCardByAccount() {
        self.present(
            title: "alert_creditcard_title".localized,
            message: "alert_creditcard_message".localized
        )
    }
    
}
        
// MARK: - Deletation
extension AlertManager {
    
    func deleteAccount(account: AccountModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_account_delete_title".localized,
            message: "alert_account_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let accountID = account._id {
                    await AccountStore.shared.deleteAccount(accountID: accountID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
}
