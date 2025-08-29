//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 29/08/2025.
//

import Foundation
import NotificationKit
import Models
import Preferences

public extension NotificationsManager {
  
  static func notifMessage(for subscription: SubscriptionModel) -> String {
    let daysBefore = SubscriptionPreferences.shared.dayBeforeReceiveNotification
    let notifMessage = subscription.type == .expense ? Word.Notifications.willRemoved : Word.Notifications.willAdded
    return "\(subscription.amount)\(UserCurrency.symbol) \(notifMessage) \(daysBefore) \(Word.Classic.days). (\(subscription.name))"
  }
  
  static func dateNotif(for subscription: SubscriptionModel) -> Date {
    var components = Calendar.current.dateComponents(
      [.minute, .hour, .day, .month, .year],
      from: subscription.frequencyDate
    )
    components.hour = 10
    components.minute = 0
    components.timeZone = TimeZone.current
    return Calendar.current.date(from: components) ?? subscription.frequencyDate
  }
  
}
