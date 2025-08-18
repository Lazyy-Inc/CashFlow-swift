//
//  AlertManager+Extensions.swift
//  Features
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import AlertKit
import SwiftUI
import CoreModule
import ContributionModule

public extension AlertManager {
    
    func deleteSavingsPlan(savingsPlan: SavingsPlanModel, dismissAction: DismissAction? = nil) {
        self.present(
            title: "alert_savingsplan_delete_title".localized,
            message: "alert_savingsplan_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let savingsPlanID = savingsPlan.id {
                    await SavingsPlanStore.shared.deleteSavingsPlan(savingsPlanID: savingsPlanID)
                    if let dismissAction { dismissAction() }
                }
            }
        )
    }
    
}
