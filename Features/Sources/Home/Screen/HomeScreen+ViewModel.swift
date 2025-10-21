//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 21/10/2025.
//

import Foundation
import Preferences
import Stores
import Dependencies
import NotificationKit
import Core

extension HomeScreen {
    
    @Observable
    final class ViewModel {
        
        @ObservationIgnored
        @Dependency(\.accountStore) var accountStore
        
        @ObservationIgnored
        @Dependency(\.transactionStore) var transactionStore
        
        var incomesThisMonth: String = "+" + 0.toCurrency()
        var expensesThisMonth: String = "-" + 0.toCurrency()
        
    }
    
}

extension HomeScreen.ViewModel {
    
    func getIncomesThisMonth() {
        let incomes = transactionStore.getIncomes(in: .now)
            .map(\.amount)
            .reduce(0, +)
        
        self.incomesThisMonth =  "+" + incomes.toCurrency()
    }
    
    func getExpensesThisMonth() {
        let expenses = transactionStore.getExpenses(in: .now)
            .map(\.amount)
            .reduce(0, +)
        
        self.expensesThisMonth = "-" + expenses.toCurrency()
    }
    
}

// MARK: - Public functions
extension HomeScreen.ViewModel {
    
    func loadHomeScreen() async {
        @Dependency(\.accountStore) var accountStore
        @Dependency(\.transactionStore) var transactionStore
        @Dependency(\.budgetStore) var budgetStore
        @Dependency(\.subscriptionStore) var subscriptionStore
        
        await AppManager.shared.resetAllAccountData()
        
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
            async let transactionsTask: () = transactionStore.fetchTransactionsOfCurrentMonth(accountID: accountID)
            async let budgetsTask: () = budgetStore.fetchBudgets(accountID: accountID)
            async let subscriptionsTask: () = subscriptionStore.fetchSubscriptions(accountID: accountID)
            
            _ = await (transactionsTask, budgetsTask, subscriptionsTask)
            
            await scheduleNotificationsOfSubscriptions()
            
            getExpensesThisMonth()
            getIncomesThisMonth()
        }
    }
    
}

// MARK: - Private functions
extension HomeScreen.ViewModel {
    
    @concurrent
    private func scheduleNotificationsOfSubscriptions() async {
        @Dependency(\.subscriptionStore) var subscriptionStore
        
        let preferencesSubscription: SubscriptionPreferences = .shared
        
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
