//
//  TurboBudgetApp.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//

import SwiftUI
import AlertKit
import NotificationKit
import TheoKit
import Core
import OnboardingModule
import Preferences
import DesignSystem
import Sentry
import Stores
import Events
import Dependencies

@main
struct TurboBudgetApp: App {
    
    // MARK: Managers
    @StateObject private var appManager: AppManager = .shared
    @StateObject private var appearanceManager = AppearanceManager()
    @StateObject private var purchasesManager = PurchasesManager()
    @StateObject private var alertManager: AlertManager = .shared
    @StateObject private var themeManager: ThemeManager = .shared
    @StateObject private var filterManager: FilterManager = .shared
    @StateObject private var successfullModalManager: SuccessfullModalManager = .shared
    @StateObject private var networkMonitor = NetworkMonitor()
    
    // MARK: Stores
    @StateObject private var userStore: UserStore = .shared
    @Dependency(\.accountStore) var accountStore: AccountStore
    @StateObject private var transferStore: TransferStore = .shared
    @StateObject private var creditCardStore: CreditCardStore = .shared
    
    // MARK: Environments
    @Environment(\.scenePhase) private var scenePhase
    
    // MARK: Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    @StateObject private var preferencesSubscription: SubscriptionPreferences = .shared
        
    // MARK: Init
    init() {
        SentrySDK.start { options in
            options.dsn = ProcessInfo.processInfo.environment["SENTRY_API_KEY"] ?? ""
            options.sendDefaultPii = true
        }
    }
    
    // MARK: - View
    var body: some Scene {
        WindowGroup {
            Group {
                if !preferencesGeneral.isAlreadyOpen {
                    OnboardingScreen()
                } else {
                    switch appManager.appState {
                    case .idle:
                        SplashScreenView()
                    case .loading:
                        SplashScreenView()
                    case .success:
                        Group {
                            if preferencesSecurity.isSecurityReinforced {
                                if scenePhase == .active {
                                    RootScreen()
                                } else {
                                    Image("LaunchScreen")
                                        .resizable()
                                        .edgesIgnoringSafeArea([.bottom, .top])
                                }
                            } else {
                                RootScreen()
                            }
                        }
                        .task {
                            if !appManager.isStartDataLoaded {
                                await accountStore.fetchAccounts()
                                await appManager.loadStartData()
                                appManager.isStartDataLoaded = true
                            }
                        }
                    case .needLogin:
                        LoginBackScreen()
                    case .noInternet:
                        NoInternetView()
                    }
                }
            }
            .overlay(alignment: .bottom) {
                SuccessfullCreationView()
                    .environmentObject(successfullModalManager)
            }
            .environmentObject(appManager)
            .environmentObject(appearanceManager)
            .environmentObject(purchasesManager)
            .environmentObject(alertManager)
            .environmentObject(themeManager)
            .environmentObject(filterManager)
            .environmentObject(successfullModalManager)
            
            .environmentObject(userStore)
            .environmentObject(transferStore)
            .environmentObject(creditCardStore)
            
            .preferredColorScheme(appearanceManager.appearance.colorScheme)
            .alert(alertManager)
            .task {
                if !networkMonitor.isConnected {
                    appManager.appState = .noInternet
                    return
                }
                
                await purchasesManager.loadProducts()
                
                do {
                    try await userStore.loginWithToken()
                    if let user = userStore.currentUser, user.isPremium == false, purchasesManager.isCashFlowPro {
                        await UserStore.shared.update(body: .init(isPremium: true))
                    }
                    appManager.appState = .success
                } catch {
                    appManager.appState = .needLogin
                }
            }
            .onChange(of: networkMonitor.isConnected) { _, newValue in
                Task {
                    if newValue {
                        try await userStore.loginWithToken()
                        appManager.appState = .success
                    } else {
                        appManager.appState = .noInternet
                    }
                }
            }
            .onAppear {
                TKDesignSystem.fontBold = "Satoshi-Bold"
                TKDesignSystem.fontMedium = "Satoshi-Medium"
                TKDesignSystem.fontRegular = "Satoshi-Regular"
                
                EventService.initialize(projectName: "CashFlow", platform: "iOS")
            }
        }
    } // body
} // struct
