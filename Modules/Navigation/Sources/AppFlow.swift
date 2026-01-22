//
//  File.swift
//  Navigation
//
//  Created by Theo Sementa on 22/01/2026.
//

import Foundation
import NavigationKit

public enum AppFlow: AppFlowProtocol {
    case home
    case subscriptions
    case savings
    case analysis
    case account
    
    case addTransaction
    case successfulModal
}
