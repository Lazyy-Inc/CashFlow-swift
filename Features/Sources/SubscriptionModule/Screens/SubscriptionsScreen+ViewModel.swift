//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 17/10/2025.
//

import Foundation
import Dependencies
import Models

// MARK: - Stored variables
extension SubscriptionsScreen {
    
    @Observable
    final class ViewModel {
            
        @ObservationIgnored
        @Dependency(\.subscriptionStore) var subscriptionStore
        
    }
    
}

extension SubscriptionsScreen.ViewModel {
    
    var totalAnnualy: Double {
        var amount: Double = 0
        for subscription in subscriptionStore.subscriptions {
            switch subscription.frequency {
            case .weekly:
                amount += subscription.amount * 52
            case .monthly:
                amount += subscription.amount * 12
            case .yearly:
                amount += subscription.amount
            }
        }
        return amount
    }
    
    var totalMonthly: Double {
        var amount: Double = 0
        for subscription in subscriptionStore.subscriptions {
            switch subscription.frequency {
            case .weekly:
                amount += subscription.amount * 4
            case .monthly:
                amount += subscription.amount
            default:
                continue
            }
        }
        return amount
    }
    
}
