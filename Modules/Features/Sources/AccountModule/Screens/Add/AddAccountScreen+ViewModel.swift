//
//  AddAccountScreen+ViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/02/2024.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores
import NetworkKit

// MARK: - Stored variables
extension AddAccountScreen {
    
    @Observable
    final class ViewModel: AddViewModel {
        
        var type: AccountType
        var account: AccountModel?
        
        var name: String = ""
        var balance: String = ""
        var maxAmount: String = ""
                
        var accountPlaceholder: String = ""
        var balancePlaceholder: String = ""
        var maxAmountPlaceholder: String = ""
        
        var isAlertLeavePresented: Bool = false
        
        @ObservationIgnored
        @Dependency(\.accountStore) var accountStore

        // init
        init(type: AccountType, account: AccountModel?) {
            self.type = type
            self.account = account
            if let account {
                name = account.name
                maxAmount = account.maxAmount?.formatted() ?? ""
            }
            
            randomAccountPlaceholder()
            randomBalancePlaceholder()
            randomMaxAmountPlaceholder()
        }
    }
    
}

// MARK: - Computed variables
extension AddAccountScreen.ViewModel {
    
    var navigationTitle: String {
        return account == nil ? Word.Title.Account.new : Word.Title.Account.update
    }
    
    var actionButtonTitle: String {
        return account == nil ? "create_account_validation_button" : "edit_account_validation_button"
    }
    
    var isModelInCreation: Bool {
        if !name.isBlank || balance.toDouble() != 0 || !maxAmount.isBlank {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        if !name.isBlank {
            return true
        }
        return false
    }
    
}

extension AddAccountScreen.ViewModel {
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            dismiss()
        }
    }
    
    func validationAction(dismiss: DismissAction) async {
        NetworkService.cancelAllTasks()
        VibrationManager.vibration()
        if account == nil {
            await createAccount(dismiss: dismiss)
        } else {
            await updateAccount(dismiss: dismiss)
        }
    }
    
}

// MARK: - Private functions
extension AddAccountScreen.ViewModel {
    
    private func createAccount(dismiss: DismissAction? = nil) async {
        let body: AccountModel
        
        if type == .classic {
            body = .init(
                name: name,
                balance: balance.toDouble(),
                typeNum: AccountType.classic.rawValue
            )
        } else {
            body = .init(
                name: name,
                balance: balance.toDouble(),
                typeNum: AccountType.savings.rawValue,
                maxAmount: maxAmount.toDouble()
            )
        }
        
        await accountStore.createAccount(body: body)
        if let dismiss { dismiss() }
    }
    
    private func updateAccount(dismiss: DismissAction) async {
        guard let account, let accountID = account._id else { return }
        
        let body: AccountModel
        
        if type == .classic {
            body = .init(name: name)
        } else {
            body = .init(
                name: name,
                maxAmount: maxAmount.toDouble()
            )
        }
        
        await accountStore.updateAccount(accountID: accountID, body: body)
        dismiss()
    }
}

// MARK: - Private functions UI
extension AddAccountScreen.ViewModel {
    
    private func randomAccountPlaceholder() {
        let placeholdersAvailable: [String] = [
            "create_account_field_name_placeholder_one",
            "create_account_field_name_placeholder_two",
            "create_account_field_name_placeholder_three",
            "create_account_field_name_placeholder_four",
            "create_account_field_name_placeholder_five"
        ]
        
        self.accountPlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
    private func randomBalancePlaceholder() {
        let placeholdersAvailable: [String] = [
            10_000.formatted(), 20_000.formatted(), 30_000.formatted(), 40_000.formatted()
        ]
        
        self.balancePlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
    private func randomMaxAmountPlaceholder() {
        let placeholdersAvailable: [String] = [
            20_000.formatted(), 50_000.formatted(), 100_000.formatted(), 150_000.formatted()
        ]
        
        self.maxAmountPlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
}
