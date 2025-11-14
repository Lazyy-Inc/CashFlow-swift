//
//  AppTabs.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import Foundation

public enum AppTabs: Int, CaseIterable {
    case home = 0
    case subscriptions = 1
    case savings = 2
    case analysis = 3
    case account = 4
}

public extension AppTabs {
    
    var icon: String {
        switch self {
        case .home:             return "iconHouse"
        case .subscriptions:    return "iconClockRepeat"
        case .savings:          return "iconPiggyBank"
        case .analysis:       return "iconPieChart"
        case .account:          return "iconPerson"
        }
    }
    
    var text: String {
        switch self {
        case .home:             return "tabbar_home_tab"
        case .subscriptions:    return "tabbar_subscriptions_tab"
        case .savings:          return "tabbar_savings_tab"
        case .analysis:         return "tabbar_analysis_tab"
        case .account:          return "tabbar_account_tab"
        }
    }
    
}
