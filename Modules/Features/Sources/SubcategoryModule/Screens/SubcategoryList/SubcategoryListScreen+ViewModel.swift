//
//  SubcategoryHomeViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/07/2024.
//

import Foundation
import Core
import TransactionModule
import Models
import Providers

extension SubcategoryListScreen {
    
    final class ViewModel: ObservableObject {
        @Published var selectedSubcategory: SubcategoryModel?        
        @Published var searchText: String = ""
        
        // MARK: Constants
        private let transactionDataSource: TransactionProvider
        
        // MARK: Init
        init(transactionDataSource: TransactionProvider = DefaultTransactionProvider.shared) {
            self.transactionDataSource = transactionDataSource
        }
    }
    
}

extension SubcategoryListScreen.ViewModel {
    
    func isDisplayChart(category: CategoryModel) -> Bool {
        if category.isToCategorized {
            return false
        } else {
            return transactionDataSource.transactions(for: .category(category, month: .now)).isNotEmpty
        }
    }
    
}
