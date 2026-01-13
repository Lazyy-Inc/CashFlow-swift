//
//  SavingsAccountsListView.swift
//  CashFlow
//
//  Created by Theo Sementa on 23/11/2023.
//

import SwiftUI
import AlertKit
import Navigation
import DesignSystem
import Core
import Dependencies
import Models
import Stores

public struct SavingsAccountsListView: View {
        
    // Environment
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var purchaseManager: PurchasesManager
    @Dependency(\.accountStore) var accountStore: AccountStore
    @Dependency(\.savingsAccountStore) private var savingsAccountStore
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText: String = ""
    
    // Computed variables
    var totalSavings: Double {
        return accountStore.savingsAccounts
            .map { $0.balance }
            .reduce(0, +)
    }
    
    var columns: [GridItem] {
        if UIDevice.isIpad {
            return [GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16), GridItem(spacing: 16)]
        } else {
            return [GridItem(spacing: 16), GridItem(spacing: 16)]
        }
    }
    
    var savingsAccountsFiltered: [AccountModel] {
        return accountStore.savingsAccounts.search(searchText)
    }
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: Word.Main.savingsAccounts,
                actionButton: .init(
                    title: "word_create".localized,
                    action: {
                        if purchaseManager.isCashFlowPro || accountStore.savingsAccounts.isEmpty {
                            router.push(.savingsAccount(.create))
                        } else {
                            alertManager.showPaywall(router: router)
                        }
                    },
                    isDisabled: false
                ),
                placeholder: "word_search".localized,
                searchText: $searchText.animation()
            )
        } content: { _ in
            VStack(spacing: 32) {
                VStack(spacing: 0) {
                    Text(totalSavings.toCurrency())
                        .font(.Display.extraLarge)
                        .foregroundStyle(Color.Text.primary)
                    
                    Text(Word.SavingsAccount.totalSavings)
                        .font(.Body.medium)
                        .foregroundStyle(Color.Background.bg600)
                }
                
                LazyVGrid(columns: columns, spacing: 16, content: {
                    ForEach(savingsAccountsFiltered) { account in
                        NavigationButtonView(
                            route: .push,
                            destination: AppDestination.savingsAccount(.detail(savingsAccount: account)),
                            onNavigate: { savingsAccountStore.currentAccount = account },
                            label: { SavingsAccountRowView(savingsAccount: account) }
                        )
                    }
                })
                .padding(.horizontal, Padding.large)
            }
            .emptyState(condition: accountStore.savingsAccounts.isEmpty) {
                CustomEmptyView(type: .noSavingsAccounts, isPlain: true)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountsListView()
}
