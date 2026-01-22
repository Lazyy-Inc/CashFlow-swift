//
//  NavigationRegistery+SettingsDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerSettingsRoutes() {
        self.register(SettingsDestination.self) { destination in
            switch destination {
            case .home:
                AnyView(SettingsScreen())
            case .debug:
                AnyView(SettingsDebugView())
            case .general:
                AnyView(SettingsGeneralView())
            case .security:
                AnyView(SettingsSecurityView())
            case .appearance:
                AnyView(SettingsAppearenceView())
            case .display:
                AnyView(SettingsDisplayView())
            case .account:
                AnyView(SettingsAccountScreen())
            case .subscription:
                AnyView(SettingsSubscriptionScreen())
            case .statistics:
                AnyView(SettingsStatisticsScreen())
            case .credits:
                AnyView(SettingsCreditsView())
            case .applePay:
                AnyView(SettingsApplePayView())
            }
        }
    }
    
}
