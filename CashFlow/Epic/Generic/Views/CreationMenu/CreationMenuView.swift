//
//  CreationMenuView.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/12/2024.
//

import SwiftUI
import AlertKit
import Navigation
import Core
import Stores

struct CreationMenuView: View {
    
    @Dependency(\.accountStore) var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var appManager: AppManager
    
    @Environment(\.theme) private var theme
    
    @State private var isPresented: Bool = false
    
    var router: Router<AppDestination>? {
        return AppRouterManager.shared.router(for: .home)
    }
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            ForEach(Array(menuActions.enumerated()), id: \.offset) { index, action in
                CreationMenuButton(action: action) {
                    appManager.isMenuPresented = false
                    VibrationManager.vibration()
                }
                .fullWidth(.leading)
                .offset(y: isPresented ? 0 : 50)
                .opacity(isPresented ? 1 : 0)
                .animation(
                    .spring(response: 0.3)
                    .delay(Double(index) * 0.1),
                    value: isPresented
                )
            }
        }
        .foregroundStyle(Color.Text.primary)
        .padding()
        .padding([.top, .leading])
        .fullSize(alignment: .top)
        .background(
            Color.Text.primary.opacity(0.1)
                .ignoresSafeArea()
                .blur(radius: 10)
                .onTapGesture {
                    withAnimation {
                        appManager.isMenuPresented = false
                    }
                }
        )
        .onAppear {
            isPresented = true
        }
    } // body
} // struct

extension CreationMenuView {
    
    private var menuActions: [CreationMenuAction] {
        if let router, accountStore.selectedAccount != nil {
            let actions: [CreationMenuAction] = [
                CreationMenuAction(
                    title: Word.Main.savingsAccount,
                    icon: .iconLandmark,
                    destination: .savingsAccount(.create),
                    isDisabled: !accountStore.savingsAccounts.isEmpty && !store.isCashFlowPro,
                    onTapAction: {
                        if !accountStore.savingsAccounts.isEmpty && !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                CreationMenuAction(
                    title: "word_account".localized,
                    icon: .iconPerson,
                    destination: .account(.create),
                    isDisabled: !accountStore.accounts.isEmpty && !store.isCashFlowPro,
                    onTapAction: {
                        if !accountStore.accounts.isEmpty && !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                CreationMenuAction(
                    title: Word.Classic.budget,
                    icon: .iconPieChart,
                    destination: .budget(.create),
                    isDisabled: !store.isCashFlowPro,
                    onTapAction: {
                        if !store.isCashFlowPro {
                            alertManager.showPaywall(router: router)
                        }
                    }
                ),
                CreationMenuAction(
                    title: Word.Main.savingsPlan,
                    icon: .iconPiggyBank,
                    destination: .savingsPlan(.create)
                ),
                CreationMenuAction(
                    title: Word.Main.transfer,
                    icon: .iconSend,
                    destination: .transfer(.create())
                ),
                CreationMenuAction(
                    title: Word.Main.subscription,
                    icon: .iconClockRepeat,
                    destination: .subscription(.create)
                ),
                CreationMenuAction(
                    title: Word.Main.transaction,
                    icon: .iconBanknote,
                    destination: .transaction(.create)
                )
            ]
            
// #if DEBUG
//            actions.append(
//                CreationMenuAction(
//                    title: "TBL Scan QRCode",
//                    icon: .iconPeage,
//                    destination: .shared(.qrCodeScanner)
//                )
//            )
// #endif
            
            return actions
        } else {
            return [
                CreationMenuAction(
                    title: "word_account".localized,
                    icon: .iconPerson,
                    destination: .account(.create)
                )
            ]
        }
    }
    
}

// MARK: - Preview
#Preview {
    CreationMenuView()
}
