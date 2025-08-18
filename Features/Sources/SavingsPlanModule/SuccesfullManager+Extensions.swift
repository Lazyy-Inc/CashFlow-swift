//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import CoreModule
import SwiftUI

public extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulSavingsPlan(type: SuccessfulType, savingsPlan: SavingsPlanModel) {
        self.title = Word.Successful.SavingsPlan.title(type: type)
        self.subtitle = Word.Successful.SavingsPlan.description(type: type)
        self.content = AnyView(SavingsPlanRowView(savingsPlan: savingsPlan))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
