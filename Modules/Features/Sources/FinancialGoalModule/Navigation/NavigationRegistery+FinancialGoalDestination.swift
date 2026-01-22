//
//  NavigationRegistery+FinancialGoalDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerFinancialGoalRoutes() {
        self.register(SavingsPlanDestination.self) { destination in
            switch destination {
            case .list:
                AnyView(SavingsPlanListScreen())
            case .create:
                AnyView(AddFinancialGoalScreen())
            case .update(let savingsPlan):
                AnyView(AddFinancialGoalScreen(savingsPlan: savingsPlan))
            case .detail(let savingsPlan):
                AnyView(FinancialGoalDetailsScreen(savingsPlan: savingsPlan))
            }
        }
    }
    
}
