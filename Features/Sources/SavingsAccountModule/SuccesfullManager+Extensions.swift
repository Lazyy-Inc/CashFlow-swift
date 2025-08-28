//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Core
import SwiftUI
import DesignSystem
import TransactionModule
import Models

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulTransaction(type: SuccessfulType, transaction: TransactionModel) {
        self.title = Word.Successful.Transaction.title(type: type)
        self.subtitle = Word.Successful.Transaction.description(type: type)
        self.content = AnyView(TransactionRowView(transaction: transaction).disabled(true))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}
