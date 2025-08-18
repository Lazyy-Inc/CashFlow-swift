//
//  SettingsSubscriptionScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/12/2024.
//

import SwiftUI
import NotificationKit
import CoreModule
import PreferenceModule
import Dependencies
import SubscriptionModule

struct SettingsSubscriptionScreen: View {
    
    @Dependency(\.subscriptionStore) private var subscriptionStore
    @StateObject private var preferencesSubscription: SubscriptionPreferences = .shared
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Toggle(isOn: $preferencesSubscription.isNotificationsEnabled) {
                    Text(Word.Classic.notifications)
                }
                if preferencesSubscription.isNotificationsEnabled {
                    Picker("", selection: $preferencesSubscription.dayBeforeReceiveNotification) {
                        ForEach(1...7, id: \.self) { day in
                            Text("\(day) \(Word.Notifications.daysBefore)").tag(day)
                        }
                    }
                }
            } footer: {
                Text(Word.Notifications.footer)
            }
        }
        .navigationTitle(Word.Main.subscription)
        .navigationBarTitleDisplayMode(.inline)
        .onChangeAsync(of: preferencesSubscription.isNotificationsEnabled) {
            if $0 {
                if await NotificationsManager.shared.requestNotificationPermission() {
                    for subscription in subscriptionStore.subscriptions {
                        await NotificationsManager.shared.scheduleNotification(
                            for: .init(
                                id: "\(subscription.id)",
                                title: "CashFlow",
                                message: subscription.notifMessage,
                                date: subscription.dateNotif
                            ),
                            daysBefore: preferencesSubscription.dayBeforeReceiveNotification
                        )
                    }
                } else {
                    preferencesSubscription.isNotificationsEnabled = false
                    return
                }
            } else {
                NotificationsManager.shared.removeAllPendingNotifications()
            }
        }
        .onChangeAsync(of: preferencesSubscription.dayBeforeReceiveNotification) {
            NotificationsManager.shared.removeAllPendingNotifications()
            for subscription in subscriptionStore.subscriptions {
                await NotificationsManager.shared.scheduleNotification(
                    for: .init(
                        id: "\(subscription.id)",
                        title: "CashFlow",
                        message: subscription.notifMessage,
                        date: subscription.dateNotif
                    ),
                    daysBefore: $0
                )
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsSubscriptionScreen()
}
