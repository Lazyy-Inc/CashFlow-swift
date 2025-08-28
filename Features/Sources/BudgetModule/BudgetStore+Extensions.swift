//
//  BudgetStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import CoreModule
import StatsKit
import SwiftUI
import EventModule
import Models

public extension BudgetStore {
    
    var budgetsByCategory: [CategoryModel: [BudgetModel]] {
        let groupedBySubcategory = Dictionary(grouping: budgets) { $0.category }
        return groupedBySubcategory
            .compactMap { entry -> (key: CategoryModel, value: [BudgetModel])? in
                guard let key = entry.key else { return nil }
                return (key: key, value: entry.value)
            }
            .sorted(by: { $0.key.name < $1.key.name })
            .reduce(into: [CategoryModel: [BudgetModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
    @MainActor
    func fetchBudgets(accountID: Int) async {
        do {
            self.budgets = try await BudgetService.fetchAll(for: accountID)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createBudget(accountID: Int, body: BudgetModel) async -> BudgetModel? {
        do {
            let budget = try await BudgetService.create(accountID: accountID, body: body)
            self.budgets.append(budget)
            EventService.sendEvent(key: EventKeys.budgetCreated)
            return budget
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateBudget(budgetID: Int, body: BudgetModel) async {
        do {
            let budget = try await BudgetService.update(budgetID: budgetID, body: body)
            if let index = self.budgets.firstIndex(where: { $0.id == budgetID }) {
                self.budgets[index] = budget
                EventService.sendEvent(key: EventKeys.budgetUpdated)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteBudget(budgetID: Int) async {
        do {
            try await BudgetService.delete(budgetID: budgetID)
            if let index = self.budgets.firstIndex(where: { $0.id == budgetID }) {
                self.budgets.remove(at: index)
                EventService.sendEvent(key: EventKeys.budgetDeleted)
            }
        } catch { NetworkService.handleError(error: error) }
    }
}

public extension BudgetModel {
    
    var category: CategoryModel? {
        return CategoryStore.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryStore.shared.findSubcategoryById(subcategoryID)
    }
    
    var name: String {
        if let subcategory {
            return subcategory.name
        } else if let category {
            return category.name
        } else {
            return ""
        }
    }
    
    var color: Color {
        return category?.color ?? .gray
    }
    
    var currentAmount: Double {
        guard let subcategory else { return 0 }

        var amount: Double = 0.0
        
        for transaction in subcategory.transactions where transaction.category != nil {
            let subcategoryOfTransaction = transaction.subcategory
            
            if transaction.type == .expense
                && subcategoryOfTransaction == subcategory
                && Calendar.current.isDate(transaction.date, equalTo: Date(), toGranularity: .month) {
                amount += transaction.amount
            }
        }
        
        return amount
    }
    
    var isExceeded: Bool {
        return currentAmount > amount
    }
    
}
