//
//  SuccessfullModalManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/08/2024.
//

import SwiftUI
import CoreModule

extension SuccessfullModalManager {
    
    @MainActor
    func showSuccessfulTransfer(type: SuccessfulType, transfer: TransactionModel) {
        self.title = Word.Successful.Transfer.title(type: type)
        self.subtitle = Word.Successful.Transfer.description(type: type)
        self.content = AnyView(TransferRowView(transfer: transfer, location: .successfulSheet).disabled(true))
            
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isPresenting = true
        }
    }
    
}

extension SuccessfullModalManager {
    
    func resetData() {
        self.title = ""
        self.subtitle = ""
        self.content = EmptyView()
    }
    
}
