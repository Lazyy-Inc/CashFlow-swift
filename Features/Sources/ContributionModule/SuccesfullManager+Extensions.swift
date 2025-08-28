//
//  SuccesfullManager+Extensions.swift
//  Features
//
//  Created by Theo Sementa on 16/08/2025.
//

import Foundation
import CoreModule
import SwiftUI
import DesignSystemModule
import Models

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulContribution(type: SuccessfulType, savingsPlan: SavingsPlanModel, contribution: ContributionModel) {
        self.title = Word.Successful.Contribution.title(type: type)
        self.subtitle = Word.Successful.Contribution.description(type: type)
        self.content = AnyView(ContributionRowView(savingsPlan: savingsPlan, contribution: contribution))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
