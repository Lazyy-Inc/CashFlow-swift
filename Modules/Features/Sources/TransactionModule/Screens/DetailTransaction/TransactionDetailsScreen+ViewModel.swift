//
//  TransactionDetailViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/10/2023.
//

import Foundation
import SwiftUI
import Core
import Models
import Stores

extension TransactionDetailsScreen {
    
    @Observable
    class ViewModel {
        var transactionId: Int
        
        var selectedCategory: CategoryModel?
        var selectedSubcategory: SubcategoryModel?
        
        var bestCategory: CategoryModel?
        var bestSubcategory: SubcategoryModel?
        
        var currentReparitionType: RepartitionType = .notDefined
        
        @ObservationIgnored
        @Dependency(\.accountStore) private var accountStore
        
        @ObservationIgnored
        @Dependency(\.categoryStore) private var categoryStore
        
        @ObservationIgnored
        @Dependency(\.transactionStore) private var transactionStore
        
        @ObservationIgnored
        @Dependency(\.transferStore) private var transferStore
        
        init(transactionId: Int) {
            self.transactionId = transactionId
            self.currentReparitionType = transaction?.repartitionType ?? .notDefined
        }
    }
    
}

extension TransactionDetailsScreen.ViewModel {
    
    var transaction: TransactionModel? {
        if let transaction = transactionStore.transactions.first(where: { $0.id == transactionId }) {
            return transaction
        } else if let transfer = transferStore.transfers.first(where: { $0.id == transactionId }) {
            return transfer
        } else {
            return nil
        }
    }
    
}

// MARK: - Utils
extension TransactionDetailsScreen.ViewModel {
    
    func updateRepartion(_ value: RepartitionType) {
        guard let account = accountStore.selectedAccount, let accountID = account._id else { return }
        
        let body: TransactionDTO = .init(repartitionType: value.rawValue)
        
        Task.detached {
            await self.transactionStore.updateTransaction(
                accountId: accountID,
                transactionId: self.transactionId,
                body: body
            )
        }
    }
    
    @MainActor
    func updateCategory(transactionID: Int) {
        guard let account = accountStore.selectedAccount, let accountID = account._id else { return }
        
        var body: TransactionDTO = .init()
        
        if let selectedCategory, let newCategory = categoryStore.findCategoryById(selectedCategory.id) {
            body.categoryID = newCategory.id
            body.subcategoryID = nil
            
            if newCategory.id == 0 {
                selectedSubcategory = nil
            }
            
            if let selectedSubcategory, let newSubcategory = categoryStore.findSubcategoryById(selectedSubcategory.id) {
                body.subcategoryID = newSubcategory.id
            }
            
            Task {
                await transactionStore.updateTransaction(
                    accountId: accountID,
                    transactionId: transactionID,
                    body: body
                )
                
                self.selectedCategory = nil
                self.selectedSubcategory = nil
                self.bestCategory = nil
                self.bestSubcategory = nil
            }
        }
    }
    
}
