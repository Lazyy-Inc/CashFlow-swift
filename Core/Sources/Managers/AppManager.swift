//
//  AppManager.swift
//  Core
//
//  Created by Theo Sementa on 24/07/2025.
//

import Foundation
import Models
import Stores
import Dependencies
import Preferences
import NotificationKit

public final class AppManager: ObservableObject {
    @MainActor public static let shared = AppManager()
    
    @Published public var appState: ApplicationState = .idle
    
    @Published public var selectedTab: Int = 0
    @Published public var isMenuPresented: Bool = false
    
    @Published public var isStartDataLoaded: Bool = false
    @Published public var isRoutersRegistered: Bool = false
}

public extension AppManager {
 
    @MainActor
    func loadStartData() async {
        let accountStore: AccountStore = .shared
        @Dependency(\.transactionStore) var transactionStore: TransactionStore
        let subscriptionStore: SubscriptionStore = .shared
        let savingsPlanStore: SavingsPlanStore = .shared
        @Dependency(\.budgetStore) var budgetStore
        let creditCardStore: CreditCardStore = .shared
        @Dependency(\.categoryStore) var categoryStore
        
        let preferencesSubscription: SubscriptionPreferences = .shared
        
        await categoryStore.fetchCategories()
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
            await transactionStore.fetchTransactionsOfCurrentMonth(accountID: accountID)
            await subscriptionStore.fetchSubscriptions(accountID: accountID)
            await savingsPlanStore.fetchSavingsPlans(accountID: accountID)
            await budgetStore.fetchBudgets(accountID: accountID)
            await creditCardStore.fetchCreditCards(accountID: accountID)
            
            if preferencesSubscription.isNotificationsEnabled {
                for subscription in subscriptionStore.subscriptions {
                    await NotificationsManager.shared.scheduleNotification(
                        for: .init(
                            id: "\(subscription.id)",
                            title: "CashFlow",
                            message: NotificationsManager.notifMessage(for: subscription),
                            date: NotificationsManager.dateNotif(for: subscription)
                        ),
                        daysBefore: preferencesSubscription.dayBeforeReceiveNotification
                    )
                }
                
                await NotificationsManager.shared.removePendingNotification(for: "notification-oneWeekLater")
                await NotificationsManager.shared.removePendingNotification(for: "notification-twoWeekLater")
                
                await NotificationsManager.shared.scheduleNotification(
                    for: .init(
                        id: "notification-oneWeekLater",
                        title: "CashFlow",
                        message: "notification_one_week_later_message".localized,
                        date: Date().oneWeekLater
                    ),
                    daysBefore: 0
                )
                
                await NotificationsManager.shared.scheduleNotification(
                    for: .init(
                        id: "notification-twoWeekLater",
                        title: "CashFlow",
                        message: "notification_two_week_later_message".localized,
                        date: Date().twoWeekLater
                    ),
                    daysBefore: 0
                )
            }
        }
    }
    
    @MainActor
    func resetAllStoresData() {
        let transactionStore: TransactionStore = .shared
        let subscriptionStore: SubscriptionStore = .shared
        let savingsPlanStore: SavingsPlanStore = .shared
        let budgetStore: BudgetStore = .shared
        let creditCardStore: CreditCardStore = .shared
        @Dependency(\.categoryStore) var categoryStore
        
        transactionStore.reset()
        subscriptionStore.reset()
        savingsPlanStore.reset()
        budgetStore.reset()
        creditCardStore.reset()
        categoryStore.reset()
      
        NotificationsManager.shared.removeAllPendingNotifications()
    }
    
}
