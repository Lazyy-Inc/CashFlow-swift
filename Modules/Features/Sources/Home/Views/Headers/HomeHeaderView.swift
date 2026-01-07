//
//  HomeHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI
import Navigation
import Core
import Dependencies
import Stores
import DesignSystem
import AlertKit

struct HomeHeaderView: View {
    
    // MARK: Dependencies
    @Dependency(\.accountStore) var accountStore: AccountStore
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    
    // MARK: EnvironmentObject
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var purchaseManager: PurchasesManager
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var appManager: AppManager
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    
    // MARK: -
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                if let account = accountStore.selectedAccount {
                    Text(account.balance.toCurrency())
                        .font(.Title.large)
                        .contentTransition(.numericText())
                        .animation(.smooth, value: account.balance)
                }
                
                Text("home_screen_available_balance".localized)
                    .font(.Body.small)
                    .foregroundStyle(Color.Background.bg600)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !purchaseManager.isCashFlowPro {
                PremiumButtonView()
            }
            
            accountSelectorView()
        }
    }
}

// MARK: - Subviews
extension HomeHeaderView {
    
    @ViewBuilder
    func accountSelectorView() -> some View {
        if let selectedAccount = accountStore.selectedAccount {
            Menu {
                ForEach(accountStore.accounts) { account in
                    Button { accountStore.setNewAccount(account: account) } label: {
                        Text(account.name)
                    }
                }
                Button {
                    if !accountStore.accounts.isEmpty && !purchaseManager.isCashFlowPro {
                        alertManager.showPaywall(router: router)
                    } else {
                        router.push(.account(.create))
                    }
                } label: {
                    Label("account_dashboard_add_account".localized, systemImage: "plus")
                }
            } label: {
                HStack(spacing: Spacing.extraSmall) {
                    Text(selectedAccount.name)
                        .lineLimit(1)
                    
                    IconSVG(icon: "iconChevronUpDown", value: .medium)
                }
                .font(.Body.large)
                .foregroundStyle(theme.color)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    HomeHeaderView()
}
