//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import Foundation
import Navigation
import SwiftUI

public extension NavigationRegistry {
    
    func registerAccountRoutes() {
        self.register(AccountDestination.self) { destination in
            switch destination {
            case .create:
                AnyView(AddAccountScreen(type: .classic))
            case .update(let account):
                AnyView(AddAccountScreen(type: .classic, account: account))
            case .dashboard:
                AnyView(EmptyView())
            case .statistics:
                AnyView(EmptyView())
//                AnyView(AccountStatisticsScreen())
            }

        }
    }
    
}
