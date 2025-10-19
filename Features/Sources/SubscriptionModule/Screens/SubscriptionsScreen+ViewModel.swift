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
    
    var subscriptionsToPay: [SubscriptionModel] {
        let subscriptionsOfTheMonth = subscriptionStore.getSubscriptions(in: .now)
        return subscriptionsOfTheMonth
            .filter { $0.frequencyDate > Date() }
    }
    
    var subscriptionsPaid: [SubscriptionModel] {
        let subscriptionsOfTheMonth = subscriptionStore.getSubscriptions(in: .now)
        return subscriptionsOfTheMonth
            .filter { $0.lastSubscriptionDate != nil }
            .filter { Date() > $0.lastSubscriptionDate! }
    }
    
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
    
    var subtitleToPay: String {
        let incomes = subscriptionsToPay.filter({ $0.type == .income })
        let expenses = subscriptionsToPay.filter({ $0.type == .expense })
        
        let incomesToReceive = incomes.map(\.amount).reduce(0, +)
        let expensesToPay = expenses.map(\.amount).reduce(0, +)
        
        if incomes.isNotEmpty && expenses.isNotEmpty {
            return String(
                format: "subcription_need_to_pay_and_receive".localized,
                expensesToPay.toCurrency(), incomesToReceive.toCurrency()
            )
        } else if incomes.isNotEmpty && expenses.isEmpty {
            return String(
                format: "subcription_only_need_to_receive".localized,
                incomesToReceive.toCurrency()
            )
        } else if incomes.isEmpty && expenses.isNotEmpty {
            return String(
                format: "subcription_only_need_to_pay".localized,
                expensesToPay.toCurrency()
            )
        }
        
        return ""
    }
    
    var subtitlePaid: String {
        let incomes = subscriptionsPaid.filter({ $0.type == .income })
        let expenses = subscriptionsPaid.filter({ $0.type == .expense })
        
        let incomesReceived = incomes.map(\.amount).reduce(0, +)
        let expensesPaid = expenses.map(\.amount).reduce(0, +)
        
        if incomes.isNotEmpty && expenses.isNotEmpty {
            return String(
                format: "subscription_paid_and_received".localized,
                expensesPaid.toCurrency(), incomesReceived.toCurrency()
            )
        } else if incomes.isNotEmpty && expenses.isEmpty {
            return String(
                format: "subscription_only_received".localized,
                incomesReceived.toCurrency()
            )
        } else if incomes.isEmpty && expenses.isNotEmpty {
            return String(
                format: "subscription_only_paid".localized,
                expensesPaid.toCurrency()
            )
        }
        
        return ""
    }
    
}
