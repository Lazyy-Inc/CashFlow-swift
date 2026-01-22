//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 22/01/2026.
//

import Foundation
import Navigation

public protocol BaseViewModel {
    
}

public extension BaseViewModel {
 
    @MainActor
    var router: Router<AppDestination>? {
        return AppRouterManager.shared.currentRouter
    }
    
}
