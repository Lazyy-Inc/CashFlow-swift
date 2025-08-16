//
//  AlertManager+Extensions.swift
//  Features
//
//  Created by Theo Sementa on 16/08/2025.
//

import Foundation
import AlertKit
import SwiftUI
import CoreModule

public extension AlertManager {
    
    func deleteContribution(savingsPlan: SavingsPlanModel, contribution: ContributionModel) {
        self.present(
            title: "alert_contribution_delete_title".localized,
            message: "alert_contribution_delete_message".localized,
            buttonTitle: "word_delete".localized,
            isDestructive: true,
            action: {
                if let contributionID = contribution.id, let savingsPlanID = savingsPlan.id {
                    await ContributionStore.shared.deleteContribution(
                        savingsplanID: savingsPlanID,
                        contributionID: contributionID
                    )
                }
            }
        )
    }
    
}
