//
//  RootScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import CloudKit
import CoreData
import NavigationKit
import StatsKit
import CoreModule
import PreferenceModule
import DesignSystemModule
import EventModule
import CategoryModule

struct RootScreen: View {
    
    // Environment
    @EnvironmentObject private var appManager: AppManager
    @EnvironmentObject private var accountStore: AccountStore
    
    @StateObject private var homeRouter: Router<AppDestination> = .init()
    @StateObject private var analyticsRouter: Router<AppDestination> = .init()
    @StateObject private var dashboardRouter: Router<AppDestination> = .init()
    @StateObject private var categoryRouter: Router<AppDestination> = .init()
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
                        TabView(selection: $appManager.selectedTab) {
                            NavigationStackView(
                                router: homeRouter,
                                destinationContent: { AppDestination.content(for: $0) },
                                initialContent: { HomeScreen() }
                            )
                            .tag(0)
                            .toolbar(.hidden, for: .tabBar)
                            
                            NavigationStackView(
                                router: analyticsRouter,
                                destinationContent: { AppDestination.content(for: $0) },
                                initialContent: { AnalyticsScreen() }
                            )
                            .tag(1)
                            .toolbar(.hidden, for: .tabBar)
                            
                            NavigationStackView(
                                router: dashboardRouter,
                                destinationContent: { AppDestination.content(for: $0) },
                                initialContent: { AccountDashboardScreen() }
                            )
                            .tag(2)
                            .toolbar(.hidden, for: .tabBar)

                            NavigationStackView(
                                router: categoryRouter,
                                destinationContent: { AppDestination.content(for: $0) },
                                initialContent: { CategoriesListScreen() }
                            )
                            .tag(3)
                            .toolbar(.hidden, for: .tabBar)
                        }
                        .onAppear {
                            if !appManager.isRoutersRegistered {
                                routerManager.resetRouters()
                                routerManager.register(router: homeRouter, for: .home)
                                routerManager.register(router: analyticsRouter, for: .analytics)
                                routerManager.register(router: dashboardRouter, for: .dashboard)
                                routerManager.register(router: categoryRouter, for: .category)
                                appManager.isRoutersRegistered = true
                            }
                        }
                    } else {
                        NavigationStackView(
                            router: homeRouter,
                            destinationContent: { AppDestination.content(for: $0) },
                            initialContent: {
                                CustomEmptyView(
                                    type: .empty(.account),
                                    isDisplayed: true
                                )
                            }
                        )
                        .onAppear {
                            if !appManager.isRoutersRegistered {
                                routerManager.register(router: homeRouter, for: .home)
                            }
                        }
                    }
                    
                    if !routerManager.isNavigationInProgress {
                        CustomTabBar()
                    }
                }
//                .sheet(isPresented: $viewModel.showOnboarding) {
//                    OnboardingScreen()
//                }
                .blur(radius: appManager.isMenuPresented ? 12 : 0)
                .overlay {
                    if appManager.isMenuPresented {
                        CreationMenuView()
                    }
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
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase != .active {
                UserDefaults.standard.set(false, forKey: "appIsOpen")
            }
        }
        .onAppear {
            EventService.sendEvent(key: EventKeys.appSession)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    RootScreen()
}
