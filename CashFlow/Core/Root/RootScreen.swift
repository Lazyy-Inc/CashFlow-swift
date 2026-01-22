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
import Stores

import Home
import Savings
import Statistics
import SubscriptionModule
import SettingsModule
import Banners

import CategoryModule
import TransactionModule

struct RootScreen: View {
    
    // Environment
    @EnvironmentObject private var appManager: AppManager
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    @State private var homeRouter: Router<AppDestination> = .init()
    @State private var subscriptionRouter: Router<AppDestination> = .init()
    @State private var savingsRouter: Router<AppDestination> = .init()
    @State private var analysisRouter: Router<AppDestination> = .init()
    @State private var accountRouter: Router<AppDestination> = .init()
    @State private var routerManager: AppRouterManager = .shared
    @StateObject private var bannerManager: BannerManager = .shared
    
    @State private var viewModel: ViewModel = .init()
    
    // Environement
    @Environment(\.scenePhase) private var scenePhase
    
    // Preferences
    @StateObject private var preferencesSecurity: PreferencesSecurity = .shared
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // MARK: - body
    var body: some View {
        VStack {
            if viewModel.isUnlocked {
                ZStack(alignment: .bottom) {
                    if accountStore.selectedAccount != nil {
                        appContentView()
                    } else {
                        appContentWithBankAccountView()
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
            } else {
                Button {
                    viewModel.authenticate()
                } label: {
                    Text("Retry authentification") // TODO: TBL + Design
                }
            }
        }
        .bannerView(banner: $bannerManager.banner)
        .overlay(condition: viewModel.launchScreenEnd == false) {
            LaunchScreen(launchScreenEnd: $viewModel.launchScreenEnd)
        }
        .onChange(of: viewModel.launchScreenEnd) { _, newValue in
            viewModel.launchApp(newValue: newValue)
        }
        .task(id: scenePhase) {
            if scenePhase != .active {
                UserDefaults.standard.set(false, forKey: "appIsOpen")
            } else {
                await appManager.createTransactionsFromApplePay()
            }
        }
        .onAppear {
            // EventService.sendEvent(key: EventKeys.appSession)
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
                routerManager: routerManager,
                flow: AppFlow.home,
                initialContent: { HomeScreen() }
            )
            .tag(AppTabs.home)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: subscriptionRouter,
                routerManager: routerManager,
                flow: AppFlow.subscriptions,
                initialContent: { SubscriptionsScreen() }
            )
            .tag(AppTabs.subscriptions)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: savingsRouter,
                routerManager: routerManager,
                flow: AppFlow.savings,
                initialContent: { SavingsScreen() }
            )
            .tag(AppTabs.savings)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: analysisRouter,
                routerManager: routerManager,
                flow: AppFlow.analysis,
                initialContent: { AnalysisScreen() }
            )
            .tag(AppTabs.analysis)
            .toolbar(.hidden, for: .tabBar)
            
            NavigationStackView(
                router: accountRouter,
                routerManager: routerManager,
                flow: AppFlow.account,
                initialContent: { SettingsScreen() }
            )
            .tag(AppTabs.account)
            .toolbar(.hidden, for: .tabBar)
        }
    }
    
    @ViewBuilder
    func appContentWithBankAccountView() -> some View {
        if appManager.selectedTab == .account {
            NavigationStackView(
                router: accountRouter,
                routerManager: routerManager,
                flow: AppFlow.account,
                isTabPage: true,
                initialContent: { SettingsScreen() }
            )
        } else {
            NavigationStackView(
                router: homeRouter,
                routerManager: routerManager,
                flow: AppFlow.home,
                isTabPage: true,
                initialContent: {
                    VStack(spacing: .large) {
                        CustomEmptyView(type: .noAccounts)
                            .padding()
                            .fullSize()
                            .background(Color.Background.bg50)
                        
                        AsyncButton {
                            appManager.isStartDataLoaded = false
                            await appManager.loadStartData()
                        } label: {
                            Text("Reload data")
                        }
                    }
                }
            )
        }
    }
    
}

// MARK: - Preview
#Preview {
    RootScreen()
}
