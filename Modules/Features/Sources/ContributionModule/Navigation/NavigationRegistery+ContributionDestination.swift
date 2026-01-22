//
//  NavigationRegistery+ContributionDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerContributionRoutes() {
        self.register(ContributionDestination.self) { destination in
            switch destination {
            case .create(let savingsPlan):
                AnyView(AddContributionScreen(savingsPlan: savingsPlan))
            }
        }
    }
    
}
