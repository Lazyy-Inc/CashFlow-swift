//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI
import DesignSystem
import Dependencies
import Navigation
import SavingsAccountModule
import FinancialGoalModule

public struct SavingsScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.accountStore) private var accountStore
    @Dependency(\.savingsAccountStore) private var savingsAccountStore
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    
    // MARK: Computed variables
    var columns: [GridItem] {
        if UIDevice.isIpad {
            return [
                GridItem(spacing: Spacing.standard),
                GridItem(spacing: Spacing.standard),
                GridItem(spacing: Spacing.standard),
                GridItem(spacing: Spacing.standard)
            ]
        } else {
            return [
                GridItem(spacing: Spacing.standard),
                GridItem(spacing: Spacing.standard)
            ]
        }
    }
    
    // MARK: Init
    public init() { }
    
    // MARK: - View
    public var body: some View {
        ScrollView {
            VStack(spacing: Spacing.extraLarge) {
                savingsAccountsView
                financialGoalsView
            }
            .padding(Spacing.large)
        }
        .background(Color.Background.bg50)
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, Spacing.tabbar, for: .scrollContent)
        .onViewDidLoad {
            await savingsPlanStore.fetchSavingsPlans()
        }
    }
}

fileprivate extension SavingsScreen {
    
    var savingsAccountsView: some View {
        VStack(spacing: Spacing.standard) {
            Text("savings_screen_savings_account_title".localized + " - " + accountStore.savingsAmount.toCurrency())
                .fontWithLineHeight(.Title.medium)
                .fullWidth(.leading)
            
            LazyVGrid(columns: columns, spacing: Spacing.standard) {
                ForEach(accountStore.savingsAccounts) { account in
                    NavigationButtonView(
                        route: .push,
                        destination: AppDestination.savingsAccount(.detail(savingsAccount: account)),
                        onNavigate: { savingsAccountStore.currentAccount = account },
                        label: { SavingsAccountRowView(savingsAccount: account) }
                    )
                }
            }
        }
        .emptyState(condition: accountStore.savingsAccounts.isEmpty) {
            CustomEmptyView(type: .noSavingsAccounts)
        }
    }
    
    var financialGoalsView: some View {
        VStack(spacing: Spacing.standard) {
            Text("savings_screen_financial_goals_title".localized + " - " + savingsPlanStore.savingsAmount.toCurrency())
                .fontWithLineHeight(.Title.medium)
                .fullWidth(.leading)
            
            ForEach(savingsPlanStore.savingsPlans) { plan in
                NavigationButtonView(
                    route: .push,
                    destination: AppDestination.savingsPlan(.detail(savingsPlan: plan)),
                    label: { SavingsPlanRowView(savingsPlan: plan) }
                )
            }
        }
        .emptyState(condition: savingsPlanStore.savingsPlans.isEmpty) {
            CustomEmptyView(type: .noFinancialGoals)
        }
    }
    
}

// MARK: - Preview
#Preview {
    SavingsScreen()
}
