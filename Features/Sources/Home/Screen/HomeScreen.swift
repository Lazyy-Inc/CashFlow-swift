//
//  HomeView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 15/06/2023.
//
// Localizations 01/10/2023
// Refactor 18/02/2024

import SwiftUI
import StoreKit
import Navigation
import TheoKit
import DesignSystem
import Core
import Preferences

public struct HomeScreen: View {
        
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var purchasesManager: PurchasesManager
    
    @StateObject private var preferencesGeneral: PreferencesGeneral = .shared
    
    // Environment
    @Environment(\.requestReview) private var requestReview
    
    public init() {}
  
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            HomeHeaderView()
                .padding(Padding.large)
        } content: { _ in
            CarouselOfChartsView()
                .padding(.bottom, 24)
            
            VStack(spacing: 32) {
                HomeScreenSubscriptionView()
                HomeScreenRecentTransactionsView()
                HomeScreenSavingsPlanView()
            }
            .padding(.horizontal, Padding.large)
            
            Rectangle()
                .frame(height: 120)
                .opacity(0)
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(TKDesignSystem.Colors.Background.Theme.bg50)
        .onAppear {
            preferencesGeneral.numberOfOpenings += 1
            if (preferencesGeneral.numberOfOpenings % 6 == 0) && !preferencesGeneral.isApplePayEnabled {
                router.present(route: .modalFitContent, .tips(.applePayShortcut))
            }
            if preferencesGeneral.numberOfOpenings > 8 && !preferencesGeneral.isReviewPopupPresented {
                Task { @MainActor in
                    preferencesGeneral.isReviewPopupPresented = true
                    requestReview()
                }
            }
            if preferencesGeneral.numberOfOpenings % 12 == 0 && !purchasesManager.isCashFlowPro {
                router.present(route: .fullScreenCover, .shared(.paywall))
            }
            if preferencesGeneral.isAlreadyOpen && !preferencesGeneral.isWhatsNewSeen {
                router.present(route: .modalFitContent, .shared(.whatsNew))
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreen()
}
