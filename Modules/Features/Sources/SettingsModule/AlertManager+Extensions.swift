//
//  AlertManager+Extensions.swift
//  Features
//
//  Created by Theo Sementa on 19/08/2025.
//

import Foundation
import AlertKit
import SwiftUI
import Events
import Core
import Stores

extension AlertManager {
    
    func signOut(dismiss: DismissAction) {
        self.present(
            title: "alert_signout_title".localized,
            message: "",
            buttonTitle: "alert_signout_action_button".localized,
            isDestructive: true,
            action: {
                await UserStore.shared.signOut()
                AppManager.shared.appState = .needLogin
                AppManager.shared.resetAllStoresData()
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
                await UserStore.shared.deleteAccount()
                AppManager.shared.appState = .needLogin
                AppManager.shared.resetAllStoresData()
                EventService.sendEvent(key: EventKeys.userDeleted)
                dismiss()
            }
        )
    }
    
}
