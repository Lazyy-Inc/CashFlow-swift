//
//  SubscriptionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import Core
import SwiftUI
import Events
import Preferences
import DesignSystem
import Models
import Stores
import Networking

public extension SubscriptionStore {
    
    var subscriptionsByMonth: [Date: [SubscriptionModel]] {
        let groupedByMonth = Dictionary(grouping: subscriptions) { subscription in
            Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: subscription.frequencyDate))!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [SubscriptionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
}

public extension SubscriptionModel {

    var symbol: String {
        switch type {
        case .expense:  return "-"
        case .income:   return "+"
        case .transfer: return ""
        }
    }
    
    var color: Color {
        switch type {
        case .expense:
            return Color.Red.r500
        case .income:
            return Color.Primary.p500
        default:
            return .gray
        }
    }
    
}
