//
//  CreateTransactionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/10/2023.
//

import Foundation
import SwiftUI
import Core
import Dependencies
import Models
import Stores
import NetworkKit

extension AddTransactionScreen {
    
    final class ViewModel: ObservableObject, AddViewModel {
        
        var transaction: TransactionModel?
        
        @Published var transactionTitle: String = ""
        @Published var transactionAmount: String = ""
        @Published var transactionDate: Date = Date()
        @Published var selectedCategory: CategoryModel?
        @Published var selectedSubcategory: SubcategoryModel?
        @Published var repartitionType: RepartitionType = .notDefined
        
        @Published var isAlertLeavePresented: Bool = false
        
        let accountStore: AccountStore = .shared
        @Dependency(\.transactionStore) private var transactionStore: TransactionStore
        let successfullModalManager: SuccessfullModalManager = .shared
        
        var isEditing: Bool {
            return transaction != nil
        }
        
        // init
        init(transaction: TransactionModel? = nil) {
            if let transaction {
                self.transaction = transaction
                self.transactionTitle = transaction.nameDisplayed
                self.transactionAmount = transaction.amount.toString()
                self.transactionDate = transaction.date
                self.selectedCategory = transaction.category
                self.selectedSubcategory = transaction.subcategory
                self.repartitionType = transaction.repartitionType ?? .notDefined
            }
        }
        
        func bodyForCreation() -> TransactionDTO {
            return TransactionDTO.body(
                name: transactionTitle.trimmingCharacters(in: .whitespaces),
                amount: transactionAmount.toDouble(),
                type: selectedCategory?.isIncome == true ? TransactionType.income.rawValue : TransactionType.expense.rawValue,
                dateISO: transactionDate.toISO(),
                categoryID: selectedCategory?.id,
                subcategoryID: selectedSubcategory?.id,
                repartitionType: repartitionType.rawValue
            )
        }
        
        func createTransaction(dismiss: DismissAction) async {
            guard let account = accountStore.selectedAccount else { return }
            guard let accountID = account._id else { return }
            
            if let transaction = await transactionStore.createTransaction(
                accountId: accountID,
                body: bodyForCreation()
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulTransaction(type: .new, transaction: transaction)
            }
        }
        
        func updateTransaction(dismiss: DismissAction) async {
            guard let account = accountStore.selectedAccount else { return }
            guard let accountID = account._id else { return }
            guard let transactionID = transaction?.id else { return }
            
            if let transaction = await transactionStore.updateTransaction(
                accountId: accountID,
                transactionId: transactionID,
                sortTransaction: true,
                body: bodyForCreation()
            ) {
                await dismiss()
                await successfullModalManager.showSuccessfulTransaction(type: .update, transaction: transaction)
            }
        }
        
    }
    
}

// MARK: - Computed variables
extension AddTransactionScreen.ViewModel {
    
    var navigationTitle: String {
        return transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update
    }
    
    var actionButtonTitle: String {
        return transaction == nil ? Word.Classic.create : Word.Classic.edit
    }
    
}

// MARK: - Public functions
extension AddTransactionScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        NetworkService.cancelAllTasks()
        VibrationManager.vibration()
        if transaction == nil {
            await createTransaction(dismiss: dismiss)
        } else {
            await updateTransaction(dismiss: dismiss)
        }
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            dismiss()
        }
    }
    
}

// MARK: - Utils
extension AddTransactionScreen.ViewModel {
    
    func resetData() {
        transactionTitle = ""
        transactionAmount = ""
        transactionDate = Date()
        selectedCategory = nil
        selectedSubcategory = nil
    }
    
}

// MARK: - Verification
extension AddTransactionScreen.ViewModel {
    
    var isModelInCreation: Bool {
        if selectedCategory != nil || selectedSubcategory != nil || !transactionTitle.isEmpty || transactionAmount.toDouble() != 0 {
            return true
        }
        return false
    }
    
    var isModelValid: Bool {
        if !transactionTitle.isBlank && transactionAmount.toDouble() != 0.0 && selectedCategory != nil {
            return true
        }
        return false
    }
    
}
