//
//  efefe.swift
//  Features
//
//  Created by Theo Sementa on 19/08/2025.
//

import Foundation
import Core
import SwiftUI
import Models
import DesignSystem

public extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulTransfer(type: SuccessfulType, transfer: TransactionModel) {
        self.title = Word.Successful.Transfer.title(type: type)
        self.subtitle = Word.Successful.Transfer.description(type: type)
        self.content = AnyView(FinancialItemRowView(financialItem: transfer, isTransfer: true).disabled(true))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
