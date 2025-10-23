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
import Dependencies

extension TransactionDetailsScreen {
    
    @Observable
    class ViewModel {
        var transactionId: Int
        var transaction: TransactionModel?
        
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
        
        init(transactionId: Int) {
            self.transactionId = transactionId
            self.transaction = transactionStore.transactions.first { $0.id == transactionId }
            self.currentReparitionType = transaction?.repartitionType ?? .notDefined
        }
    }
    
}

// MARK: - Utils
extension TransactionDetailsScreen.ViewModel {
    
    func updateRepartion(_ value: RepartitionType) {
        guard let account = accountStore.selectedAccount, let accountID = account._id else { return }
        
        let body: TransactionDTO = .init(repartitionType: value.rawValue)
        
        Task {
            await transactionStore.updateTransaction(
                accountId: accountID,
                transactionId: transactionId,
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
