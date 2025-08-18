//
//  CategoryStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import NetworkKit
import CoreModule
//import TransactionModule

public extension CategoryStore {
    
    @MainActor
    func fetchCategories() async {
        do {
            let categories = try await NetworkService.sendRequest(
                apiBuilder: CategoryAPIRequester.fetchCategories,
                responseModel: [CategoryDTO].self
            ).map { try $0.toModel() }
            self.categories = categories
            for (index, category) in self.categories.enumerated() {
                self.categories[index].subcategories = category.subcategories?.filter { $0.isVisible }
            }
            self.subcategories = categories.flatMap { $0.subcategories ?? [] }
        } catch { NetworkService.handleError(error: error) }
    }
    
}

public extension CategoryStore {
    
    private func computeCategoryData(for month: Date) -> [Int?: CategoryTransactionData] {
        let allMonthTransactions = TransactionStore.shared.getTransactions(in: month)
        let transactionsByCategory = Dictionary(grouping: allMonthTransactions) { $0.category }
        
        return Dictionary(uniqueKeysWithValues: categories
            .compactMap { category in
                let categoryTransactions = transactionsByCategory[category, default: []]
                if categoryTransactions.isEmpty { return nil }
                return (
                    category.id,
                    CategoryTransactionData(
                        category: category,
                        transactions: categoryTransactions
                    )
                )
            })
    }
    
    private func computeSubcategoryData(for month: Date, in category: CategoryModel) -> [Int?: SubcategoryTransactionData] {
        let allMonthTransactions = TransactionStore.shared.getTransactions(for: category, in: month)
        let transactionsBySubcategory = Dictionary(grouping: allMonthTransactions) { $0.subcategory }
        
        return Dictionary(uniqueKeysWithValues: (category.subcategories ?? [])
            .compactMap { subcategory in
                let subcategoryTransactions = transactionsBySubcategory[subcategory, default: []]
                if subcategoryTransactions.isEmpty { return nil }
                return (
                    subcategory.id,
                    SubcategoryTransactionData(
                        subcategory: subcategory,
                        transactions: subcategoryTransactions
                    )
                )
            })
    }
        
    func categoriesSlices(for month: Date) -> [PieSliceData] {
        let slices = computeCategoryData(for: month)
            .values
            .filter { !$0.category.isIncome }
            .map { data in
                PieSliceData(
                    categoryID: data.category.id,
                    icon: data.category.icon,
                    value: data.totalAmount,
                    color: data.category.color
                )
            }
        return slices
    }
    
    func subcategoriesSlices(for category: CategoryModel, in month: Date) -> [PieSliceData] {
        let slices = computeSubcategoryData(for: month, in: category)
            .values
            .map { data in
                PieSliceData(
                    categoryID: category.id,
                    subcategoryID: data.subcategory.id,
                    icon: data.subcategory.icon,
                    value: data.totalAmount,
                    color: data.subcategory.color
                )
            }
        return slices
    }
}

public extension CategoryModel {
    
    var transactions: [TransactionModel] {
        return TransactionStore.shared.transactions.filter { $0.category?.id == self.id }
    }
    
    /// Transactions of type expense in a Category
    var expenses: [TransactionModel] {
        return transactions.filter { $0.type == .expense }
    }
    
    /// Transactions of type income in a Category
    var incomes: [TransactionModel] {
        return transactions.filter { $0.type == .income }
    }
    
    /// Transactions from Subscription in a Category
    var subscriptions: [TransactionModel] {
        return transactions.filter { $0.isFromSubscription == true }
    }
    
}
