//
//  AppRouterManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import NavigationKit

@MainActor
public final class AppRouterManager: RouterManager<AppFlow, AppDestination> {
    public static let shared: AppRouterManager = .init()
    
    init() {
        super.init(selectedFlow: .home)
    }
    
}
