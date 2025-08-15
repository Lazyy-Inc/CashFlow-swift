//
//  SubscriptionPreferences.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import Foundation
import Combine
import StatsKit
import EventModule

public final class SubscriptionPreferences: ObservableObject {
    public static let shared = SubscriptionPreferences()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesSubscription_isNotificationsEnabled", defaultValue: false) // Notifiaction sent at 10h00
    public var isNotificationsEnabled: Bool {
        willSet {
            if newValue { EventService.sendEvent(key: EventKeys.preferenceSubscriptionNotifications) }
            objectWillChange.send()
        }
    }
    
    @UserDefault("PreferencesSubscription_dayBeforeReceiveNotification", defaultValue: 1) // [1, 2, 3, 4, 5, 6, 7]
    public var dayBeforeReceiveNotification: Int {
        willSet { objectWillChange.send() }
    }
    
}
