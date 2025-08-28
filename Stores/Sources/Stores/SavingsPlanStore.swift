//
//  SavingsPlanStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies
import Models

@Observable
public final class SavingsPlanStore {
    public static let shared = SavingsPlanStore()
    
    public var savingsPlans: [SavingsPlanModel] = []
}

public extension SavingsPlanStore {
    
    func setNewAmount(savingsPlanID: Int, newAmount: Double) {
        if let savingsPlanIndex = savingsPlans.firstIndex(where: { $0.id == savingsPlanID }) {
            self.savingsPlans[savingsPlanIndex].currentAmount = newAmount
        }
    }
    
    func reset() {
        self.savingsPlans.removeAll()
    }
    
}

// MARK: - Dependencies
extension SavingsPlanStore: DependencyKey {
    public static var liveValue: SavingsPlanStore = .shared
}

public extension DependencyValues {
    var savingsPlanStore: SavingsPlanStore {
        get { self[SavingsPlanStore.self] }
        set { self[SavingsPlanStore.self] = newValue }
    }
}
