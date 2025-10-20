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
import Dependencies

public struct HomeScreen: View {
        
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var purchasesManager: PurchasesManager
    @Dependency(\.transactionStore) private var transactionStore
    
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
            VStack(spacing: Spacing.large) {
                TwoStatisticsRowView(
                    leftItem: .init(value: incomesThisMonth, text: "home_incomes_of_month".localized, color: .primary500),
                    rightItem: .init(value: expensesTshisMonth, text: "home_expenses_of_month".localized, color: .red)
                )
                
                HomeTopExpensesSectionView()
                
                HomeLastTransactionsSectionView()
            }
            .padding(.horizontal, Spacing.large)
        }
        .contentMargins(.bottom, Spacing.tabbar, for: .scrollContent)
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

// MARK: - Utils
extension HomeScreen {
    
    var incomesThisMonth: String {
        let incomes = transactionStore.getIncomes(in: .now)
            .map(\.amount)
            .reduce(0, +)
        
        return "+" + incomes.toCurrency()
    }
    
    var expensesTshisMonth: String {
        let expenses = transactionStore.getExpenses(in: .now)
            .map(\.amount)
            .reduce(0, +)
        
        return "-" + expenses.toCurrency()
    }
    
}

// MARK: - Preview
#Preview {
    HomeScreen()
}
