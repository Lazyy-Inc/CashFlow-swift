//
//  SubscriptionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import StatsKit
import Core
import SwiftUI
import TheoKit
import EventModule
import Preferences
import DesignSystemModule
import Models
import Stores
import NetworkModule

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
    
    var category: CategoryModel? {
        return CategoryStore.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryStore.shared.findSubcategoryById(subcategoryID)
    }

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
            return TKDesignSystem.Colors.Error.c500
        case .income:
            return .primary500
        default:
            return .gray
        }
    }
    
    var notifMessage: String {
        let daysBefore = SubscriptionPreferences.shared.dayBeforeReceiveNotification
        let notifMessage = self.type == .expense ? Word.Notifications.willRemoved : Word.Notifications.willAdded
        return "\(self.amount)\(UserCurrency.symbol) \(notifMessage) \(daysBefore) \(Word.Classic.days). (\(self.name))"
    }
    
    var dateNotif: Date {
        var components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: frequencyDate)
        components.hour = 10
        components.minute = 0
        components.timeZone = TimeZone.current
        return Calendar.current.date(from: components) ?? frequencyDate
    }
}
