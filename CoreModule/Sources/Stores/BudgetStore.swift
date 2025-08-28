//
//  BudgetStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 17/08/2025.
//

import Foundation
import Dependencies
import Models

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
