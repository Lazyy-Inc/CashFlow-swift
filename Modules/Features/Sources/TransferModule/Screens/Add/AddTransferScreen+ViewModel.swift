//
//  CreateTransferViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores
import Events

extension AddTransferScreen {
    
    @Observable
    final class ViewModel: AddViewModel {
        
        var amount: String = ""
        var date: Date = .now
        var senderAccount: AccountModel? = AccountStore.shared.selectedAccount
        var receiverAccount: AccountModel?
        
        var amountPlaceholder: String = ""
        
        var isAlertLeavePresented: Bool = false
        
        init(receiverAccount: AccountModel? = nil) {
            if let receiverAccount {
                self.receiverAccount = receiverAccount
            } else {
                self.receiverAccount = AccountStore.shared.savingsAccounts.first
            }
            
            randomAmountPlaceholder()
        }
    }
    
}

// MARK: - Computed variables
extension AddTransferScreen.ViewModel {
    
    var navigationTitle: String {
        return Word.Title.Transfer.new
    }
    
    var actionButtonTitle: String {
        return "create_transfer_validation_button"
    }
    
    var isModelInCreation: Bool {
        if !amount.isBlank {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        if amount.toDouble() != 0 && senderAccount != nil && receiverAccount != nil {
            return true
        }
        return false
    }
    
}

// MARK: - Public functions
extension AddTransferScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        await createTransfer(dismiss: dismiss)
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            // EventService.sendEvent(key: EventKeys.transferCreationCanceled)
            dismiss()
        }
    }
    
}

// MARK: - Private functions
extension AddTransferScreen.ViewModel {
    
    private func createTransfer(dismiss: DismissAction) async {
        guard let senderAccount, let receiverAccount else { return }
        guard let senderAccountID = senderAccount._id, let receiverAccountID = receiverAccount._id else { return }
        
        let transferStore: TransferStore = .shared
        let successfullModalManager: SuccessfullModalManager = .shared
        
        if let transfer = await transferStore.createTransfer(
            senderAccountID: senderAccountID,
            receiverAccountID: receiverAccountID,
            body: .init(
                amount: amount.toDouble(),
                date: date.toISO()
            )
        ) {
            await dismiss()
            await successfullModalManager.showSuccessfulTransfer(type: .new, transfer: transfer)
        }
    }
    
}

// MARK: - Private functions UI
extension AddTransferScreen.ViewModel {
    
    private func randomAmountPlaceholder() {
        self.amountPlaceholder = Int.random(in: 100...1000).toString()
    }
    
}
