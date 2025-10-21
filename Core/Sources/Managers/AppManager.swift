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
import Navigation

public final class AppManager: ObservableObject {
    @MainActor public static let shared = AppManager()
    
    @Published public var appState: ApplicationState = .idle
    
    @Published public var selectedTab: AppTabs = .home
    @Published public var isMenuPresented: Bool = false
    
    @Published public var isStartDataLoaded: Bool = false
    @Published public var isRoutersRegistered: Bool = false
}

public extension AppManager {
    
    @MainActor
    func loadStartData() async {
        if isStartDataLoaded == false {
            @Dependency(\.accountStore) var accountStore
            @Dependency(\.categoryStore) var categoryStore
            
            async let accountTask: () = accountStore.fetchAccounts()
            async let categoryTask: () = categoryStore.fetchCategories()
            
            _ = await (accountTask, categoryTask)
            
            isStartDataLoaded = true
        }
    }
    
    func createTransactionsFromApplePay() async {
        @Dependency(\.transactionStore) var transactionStore: TransactionStore
        
        let transactionsFromApplePay = UserDefaultsManager.getArrayCodable(
            key: .transactionFromApplePay,
            as: TransactionDTO.self
        )
        
        guard !transactionsFromApplePay.isEmpty else { return }
        
        await withTaskGroup(of: Void.self) { group in
            for transaction in transactionsFromApplePay {
                guard let accountID = transaction.accountId else { continue }
                
                group.addTask {
                    await transactionStore.createTransaction(accountId: accountID, body: transaction)
                }
            }
            
            await group.waitForAll()
            UserDefaultsManager.delete(key: .transactionFromApplePay)
        }
    }
    
    @MainActor
    func resetAllAccountData() {
        @Dependency(\.transactionStore) var transactionStore
        @Dependency(\.budgetStore) var budgetStore
        @Dependency(\.subscriptionStore) var subscriptionStore
        
        transactionStore.reset()
        subscriptionStore.reset()
        budgetStore.reset()
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
