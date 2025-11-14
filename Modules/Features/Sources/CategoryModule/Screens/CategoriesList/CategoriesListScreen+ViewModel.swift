//
//  CategoriesHomeViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/07/2024.
//

import Foundation
import Core
import Models
import Stores
import Dependencies

extension CategoriesListScreen {
    
    final class ViewModel: ObservableObject {
        @Published var categoryAmounts: [Int?: CategoryAmount] = [:]
        @Published var searchText: String = ""
        
        @Published var selectedDate: Date = Date()
      
        @Dependency(\.categoryStore) var categoryStore
    }
    
}

extension CategoriesListScreen.ViewModel {
  
    var categories: [CategoryModel] {
      return categoryStore.categories
    }
    
    var isChartDisplayed: Bool {
        return !TransactionStore.shared.getExpenses(in: selectedDate).isEmpty
    }
    
    var categoriesFiltered: [CategoryModel] {
        return categories.search(searchText)
    }
    
    func calculateAllAmounts(for date: Date) {
        let transactionStore: TransactionStore = .shared
        let groupedTransactions = Dictionary(grouping: transactionStore.transactions) { $0.category?.id }
        
        var newAmounts: [Int?: CategoryAmount] = [:]
        
        for (categoryId, transactions) in groupedTransactions {
            let totalAmount = transactions
                .filter { transaction in
                    let startOfMonth = date.startOfMonth ?? .now
                    let endOfMonth = date.endOfMonth ?? .now
                    return transaction.date >= startOfMonth && transaction.date <= endOfMonth
                }
                .reduce(0.0) { sum, transaction in
                    sum + transaction.amount
                }
            
            newAmounts[categoryId] = CategoryAmount(categoryId: categoryId, amount: totalAmount)
        }
        
        DispatchQueue.main.async {
            self.categoryAmounts = newAmounts
        }
    }
    
}
