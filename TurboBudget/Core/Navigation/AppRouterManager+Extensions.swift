//
//  AppRouterManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import Navigation
import CoreModule

extension AppRouterManager {
    
    func navigateToTab(_ tab: AppTabs, then: @escaping () -> Void) {
        AppManager.shared.selectedTab = tab.rawValue
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            then()
        }
    }
    
    var isNavigationInProgress: Bool {
        return routers.values.map(\.navigationPath.isNotEmpty).contains(true)
    }
    
}
