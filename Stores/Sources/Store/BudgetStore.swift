//
//  BudgetStore.swift
//  Core
//
//  Created by Theo Sementa on 17/08/2025.
//

import Foundation
import Dependencies
import Models
import NetworkModule
import Events

@Observable
public final class BudgetStore {
    public static let shared = BudgetStore()
    
    public var budgets: [BudgetModel] = []
}

public extension BudgetStore {
 
    func reset() {
        self.budgets.removeAll()
    }
    
}

public extension BudgetStore {
    
    @MainActor
    func fetchBudgets(accountID: Int) async {
        do {
            self.budgets = try await BudgetService.fetchAll(for: accountID)
        } catch { await NetworkService.handleError(error: error) }
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
            await NetworkService.handleError(error: error)
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
        } catch { await NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteBudget(budgetID: Int) async {
        do {
            try await BudgetService.delete(budgetID: budgetID)
            if let index = self.budgets.firstIndex(where: { $0.id == budgetID }) {
                self.budgets.remove(at: index)
                EventService.sendEvent(key: EventKeys.budgetDeleted)
            }
        } catch { await NetworkService.handleError(error: error) }
    }
}

// MARK: - Dependencies
extension BudgetStore: DependencyKey {
    public static var liveValue: BudgetStore = .shared
}

public extension DependencyValues {
    var budgetStore: BudgetStore {
        get { self[BudgetStore.self] }
        set { self[BudgetStore.self] = newValue }
    }
}
