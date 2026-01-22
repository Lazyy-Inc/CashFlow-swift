//
//  CreateTransactionViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/10/2023.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores
import Events
import NetworkKit
import Utilities
import ToastBannerKit

extension AddTransactionScreen {
    
    @Observable @MainActor
    final class ViewModel: BaseViewModel, AddViewModel {
        
        var transaction: TransactionModel?
        
        var transactionTitle: String = ""
        var transactionAmount: String = "0"
        var transactionDate: Date = Date()
        var selectedCategory: CategoryModel?
        var selectedSubcategory: SubcategoryModel?
        var repartitionType: RepartitionType = .notDefined
        
        var isAlertLeavePresented: Bool = false
        
        let successfullModalManager: SuccessfullModalManager = .shared
        var toastBannerService: ToastBannerService = .shared
        
        var isEditing: Bool { return transaction != nil }
        
        var namePlaceholder: String = ""
        var amountPlaceholder: String = ""
        
        @ObservationIgnored
        @Dependency(\.accountStore) var accountStore
        
        @ObservationIgnored
        @Dependency(\.transactionStore) private var transactionStore
        
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
            
            randomNamePlaceholder()
            randomAmountPlaceholder()
        }
        
    }
    
}

// MARK: - Computed variables
extension AddTransactionScreen.ViewModel {
    
    var navigationTitle: String { // TODO: TO Delete + Tolgee
        return transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update
    }
    
    var actionButtonTitle: String { // TODO: TO Delete + Tolgee
        return transaction == nil ? "create_transaction_validation_button" : "edit_transaction_validation_button"
    }
    
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

// MARK: - Public functions
extension AddTransactionScreen.ViewModel {
    
    func validationAction(dismiss: DismissAction) async {
        NetworkService.cancelAllTasks()
        do {
            try checkDatas()
            if transaction == nil {
                await createTransaction(dismiss: dismiss)
            } else {
                await updateTransaction(dismiss: dismiss)
            }
        } catch { }
    }
    
    func dismissAction(dismiss: DismissAction) {
        if isModelInCreation {
            isAlertLeavePresented.toggle()
        } else {
            if isEditing {
                // EventService.sendEvent(key: EventKeys.transactionUpdateCanceled)
            } else {
                // EventService.sendEvent(key: EventKeys.transactionCreationCanceled)
            }
            dismiss()
        }
    }
    
    func onTapSelectCategory() {
        router?.present(
            route: .sheet(style: .large),
            .category(
                .select(
                    selectedCategory: Binding(
                        get: { self.selectedCategory },
                        set: { self.selectedCategory = $0 }
                    ),
                    selectedSubcategory: Binding(
                        get: { self.selectedSubcategory },
                        set: { self.selectedSubcategory = $0 }
                    )
                )
            )
        )
    }
}

// MARK: - Private functions
extension AddTransactionScreen.ViewModel {
    
    private func bodyForCreation() -> TransactionDTO {
        return TransactionDTO.body(
            name: transactionTitle.trimmingCharacters(in: .whitespaces),
            amount: transactionAmount.toDouble(),
            type: selectedCategory?.isIncome == true ? FinancialItemType.income.rawValue : FinancialItemType.expense.rawValue,
            dateISO: transactionDate.toISO(),
            categoryID: selectedCategory?.id,
            subcategoryID: selectedSubcategory?.id,
            repartitionType: repartitionType.rawValue
        )
    }
    
    private func createTransaction(dismiss: DismissAction) async {
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        
        if let transaction = await transactionStore.createTransaction(
            accountId: accountID,
            body: bodyForCreation()
        ) {
            dismiss()
            successfullModalManager.showSuccessfulTransaction(type: .new, transaction: transaction)
        }
    }
    
    private func updateTransaction(dismiss: DismissAction) async {
        guard let account = accountStore.selectedAccount else { return }
        guard let accountID = account._id else { return }
        guard let transactionID = transaction?.id else { return }
        
        if let transaction = await transactionStore.updateTransaction(
            accountId: accountID,
            transactionId: transactionID,
            sortTransaction: true,
            body: bodyForCreation()
        ) {
            dismiss()
            successfullModalManager.showSuccessfulTransaction(type: .update, transaction: transaction)
        }
    }
    
    private func checkDatas() throws {
        if transactionAmount.isEmpty || transactionAmount.toDouble() == 0 {
            toastBannerService.send(.errorAmountMandatory)
            throw NetworkError.fieldIsIncorrectlyFilled
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

// MARK: - Private functions UI
extension AddTransactionScreen.ViewModel {
    
    private func randomNamePlaceholder() {
        let placeholdersAvailable: [String] = [
            "create_transaction_field_name_placeholder_one",
            "create_transaction_field_name_placeholder_two",
            "create_transaction_field_name_placeholder_three",
            "create_transaction_field_name_placeholder_four",
            "create_transaction_field_name_placeholder_five",
            "create_transaction_field_name_placeholder_six",
            "create_transaction_field_name_placeholder_seven",
            "create_transaction_field_name_placeholder_eight",
            "create_transaction_field_name_placeholder_nine",
            "create_transaction_field_name_placeholder_ten"
        ]
        
        self.namePlaceholder = placeholdersAvailable.randomElement() ?? ""
    }
    
    private func randomAmountPlaceholder() {
        self.amountPlaceholder = Double.random(in: 20.0...300.0).toString()
    }
    
}
