//
//  RootScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Navigation
import Core
import Preferences
import DesignSystem
import Events
import CategoryModule
import Stores
import Dependencies

import Home
import Savings
import Dashboard
import Statistics
import SubscriptionModule
import SettingsModule

struct RootScreen: View {
    
    // Environment
    @EnvironmentObject private var appManager: AppManager
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    @StateObject private var homeRouter: Router<AppDestination> = .init()
    @StateObject private var subscriptionRouter: Router<AppDestination> = .init()
    @StateObject private var savingsRouter: Router<AppDestination> = .init()
    @StateObject private var analysisRouter: Router<AppDestination> = .init()
    @StateObject private var accountRouter: Router<AppDestination> = .init()
    @StateObject private var routerManager: AppRouterManager = .shared
    
    @StateObject private var viewModel: ViewModel = .init()
    
    // Environement
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: - body
    var body: some View {
        VStack {
            if !viewModel.launchScreenEnd { LaunchScreen(launchScreenEnd: $viewModel.launchScreenEnd) }
            if viewModel.isUnlocked {
                ZStack(alignment: .bottom) {
                    if accountStore.selectedAccount != nil {
                        appContentView()
                    } else {
                        appContentWithBankAccountView()
                            .onAppear {
                                if !appManager.isRoutersRegistered {
                                    routerManager.register(router: homeRouter, for: .home)
                                    routerManager.register(router: accountRouter, for: .account)
                                }
                            }
                    }
                    
                    if !routerManager.isNavigationInProgress {
                        VStack(alignment: .trailing, spacing: Spacing.standard) {
                            PlusButtonView { appManager.isMenuPresented.toggle() }
                                .padding(.trailing, Spacing.standard)
                                .isDisplayed(appManager.selectedTab != .account)
                            
                            TabbarView(selectedTab: $appManager.selectedTab)
                        }
                    }
                }
                .blur(radius: appManager.isMenuPresented ? 12 : 0)
                .overlay(condition: appManager.isMenuPresented) {
                    CreationMenuView()
                }
                .edgesIgnoringSafeArea(.bottom)
                .ignoresSafeArea(.keyboard)
            } // End if unlocked
        }
        .padding(viewModel.isUnlocked ? 0 : 0)
        .onChange(of: viewModel.launchScreenEnd) { _, newValue in
            if accountStore.selectedAccount != nil && !preferencesGeneral.isAlreadyOpen {
                viewModel.showOnboarding = false
                preferencesGeneral.isAlreadyOpen = true
            } else if !preferencesGeneral.isAlreadyOpen {
                viewModel.showOnboarding = true
            }
            
            // LaunchScreen ended
            if newValue {
                // Already open + app close
                if !UserDefaults.standard.bool(forKey: "appIsOpen") && preferencesGeneral.isAlreadyOpen {
                    if preferencesSecurity.isBiometricEnabled {
                        viewModel.authenticate()
                    } else {
                        withAnimation { viewModel.isUnlocked = true }
                        UserDefaults.standard.set(true, forKey: "appIsOpen")
                    }
                } else {
                    withAnimation { viewModel.isUnlocked = true }
                    UserDefaults.standard.set(true, forKey: "appIsOpen")
                }
            }
        }
        .task(id: scenePhase) {
          if scenePhase != .active {
              UserDefaults.standard.set(false, forKey: "appIsOpen")
          } else {
            await appManager.createTransactionsFromApplePay()
          }
        }
        .onAppear {
            EventService.sendEvent(key: EventKeys.appSession)
        }
    } // body
} // struct

// MARK: - Subviews
extension RootScreen {
    
    @ViewBuilder
    func appContentView() -> some View {
        TabView(selection: $appManager.selectedTab) {
            NavigationStackView(
                router: homeRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { HomeScreen() }
            )
            .tag(AppTabs.home)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: subscriptionRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { SubscriptionsScreen() }
            )
            .tag(AppTabs.subscriptions)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: savingsRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { SavingsScreen() }
            )
            .tag(AppTabs.savings)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: analysisRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { StatisticsScreen() }
            )
            .tag(AppTabs.analysis)
            .toolbar(.hidden, for: .tabBar)

            NavigationStackView(
                router: accountRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { SettingsScreen() }
            )
            .tag(AppTabs.account)
            .toolbar(.hidden, for: .tabBar)
        }
        .onAppear {
            if !appManager.isRoutersRegistered {
                routerManager.resetRouters()
                routerManager.register(router: homeRouter, for: .home)
                routerManager.register(router: subscriptionRouter, for: .subscriptions)
                routerManager.register(router: savingsRouter, for: .savings)
                routerManager.register(router: analysisRouter, for: .analysis)
                routerManager.register(router: accountRouter, for: .account)
                appManager.isRoutersRegistered = true
            }
        }
    }
    
    @ViewBuilder
    func appContentWithBankAccountView() -> some View {
        if appManager.selectedTab == .account {
            NavigationStackView(
                router: accountRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: { SettingsScreen() }
            )
        } else {
            NavigationStackView(
                router: homeRouter,
                destinationContent: { AppDestination.content(for: $0) },
                initialContent: {
                    CFEmptyView(type: .noAccounts)
                        .padding()
                        .fullSize()
                        .background(Color.Background.bg50)
                }
            )
        }
    }
    
}

// MARK: - Preview
#Preview {
    RootScreen()
}
