//
//  AppRouterManager.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation
import NavigationKit

public final class AppRouterManager: ObservableObject {
    @MainActor public static let shared = AppRouterManager()
    public var routers: [AppTabs: Router<AppDestination>] = [:]
}

public extension AppRouterManager {

    func register(router: Router<AppDestination>, for tab: AppTabs) {
        return routers[tab] = router
    }
    
    func router(for tab: AppTabs) -> Router<AppDestination>? {
        return routers[tab]
    }
    
    func resetRouters() {
        routers.removeAll()
    }
    
}
