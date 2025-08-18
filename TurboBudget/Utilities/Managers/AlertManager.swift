//
//  AlertManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/08/2024.
//  Localized with Toglee on 14/04/2025

import Foundation
import AlertKit
import SwiftUI
import NavigationKit
import StatsKit
import CoreModule
import UserModule
import EventModule

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

extension AlertManager {
    
    func signOut(dismiss: DismissAction) {
        self.present(
            title: "alert_signout_title".localized,
            message: "",
            buttonTitle: "alert_signout_action_button".localized,
            isDestructive: true,
            action: {
                // TODO: Clear data
                await UserStore.shared.signOut()
                EventService.sendEvent(key: EventKeys.userLogout)
                dismiss()
            }
        )
    }
    
    func deleteUser(dismiss: DismissAction) {
        self.present(
            title: "alert_user_account_delete_title".localized,
            message: "alert_user_account_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                // TODO: Clear data
                await UserStore.shared.deleteAccount()
                EventService.sendEvent(key: EventKeys.userDeleted)
                dismiss()
            }
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
