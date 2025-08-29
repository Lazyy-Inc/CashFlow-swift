//
//  HomeHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import SwiftUI
import Navigation
import TheoKit
import Core
import Dependencies
import Stores
import DesignSystem

struct HomeHeaderView: View {
    
    @EnvironmentObject private var accountStore: AccountStore
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @EnvironmentObject private var purchaseManager: PurchasesManager
    
    // MARK: -
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 0) {
                if let account = accountStore.selectedAccount {
                    Text(account.balance.toCurrency())
                        .fontWithLineHeight(.Title.large)
                        .contentTransition(.numericText())
                        .animation(.smooth, value: account.balance)
                }
                
                Text("home_screen_available_balance".localized)
                    .fontWithLineHeight(.Body.small)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if !purchaseManager.isCashFlowPro {
              PremiumButtonView()
            }
            
            NavigationButtonView(route: .push, destination: .settings(.home)) {
                Image("iconGear")
                    .renderingMode(.template)
                    .foregroundStyle(Color.text)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeHeaderView()
}
