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
    final class ViewModel: BaseViewModel {
        
        // MARK: Dependencies
        var transaction: TransactionModel?
        
        @ObservationIgnored
        @Dependency(\.accountStore) var accountStore
        
        @ObservationIgnored
        @Dependency(\.transactionStore) private var transactionStore
        
        // MARK: States
        var title: String = ""
        var amount: String = "0"
        var date: Date = Date()
        var selectedCategory: CategoryModel?
        var selectedSubcategory: SubcategoryModel?
        var repartitionType: RepartitionType = .notDefined
        
        // MARK: Services
        let successfullModalManager: SuccessfullModalManager = .shared
        var toastBannerService: ToastBannerService = .shared
        
        // MARK: UI Variables
        var namePlaceholder: String = ""
        var isAlertLeavePresented: Bool = false
        
        // MARK: Init
        init(transaction: TransactionModel? = nil) {
            if let transaction {
                self.transaction = transaction
                self.title = transaction.nameDisplayed
                self.amount = transaction.amount.toString()
                self.date = transaction.date
                self.selectedCategory = transaction.category
                self.selectedSubcategory = transaction.subcategory
                self.repartitionType = transaction.repartitionType ?? .notDefined
            }
            
            randomNamePlaceholder()
        }
        
    }
    
}

// MARK: - Computed variables
extension AddTransactionScreen.ViewModel {
    
    var isModelInCreation: Bool {
        return selectedCategory.isNotNil
        || selectedSubcategory.isNotNil
        || title.isNotEmpty
        || amount.toDouble() != 0
    }
    
    var isEditing: Bool { transaction != nil }

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
            name: title.trimmingCharacters(in: .whitespaces),
            amount: amount.toDouble(),
            type: selectedCategory?.isIncome == true ? FinancialItemType.income.rawValue : FinancialItemType.expense.rawValue,
            dateISO: date.toISO(),
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
        if amount.isReallyEmpty || amount.toDouble() == 0 {
            toastBannerService.send(.errorAmountMandatory)
            throw NetworkError.fieldIsIncorrectlyFilled
        }
    }
    
}

// MARK: - Private UI functions
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
    
}
