//
//  AccountDashboardView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import Navigation
import DesignSystem
import Core
import CreditCardModule
import Stores

public struct AccountDashboardScreen: View { // TODO: To delete
    
    // EnvironmentObject
    @EnvironmentObject private var router: Router<AppDestination>
    @EnvironmentObject private var store: PurchasesManager
    @EnvironmentObject private var alertManager: AlertManager
    @EnvironmentObject private var appManager: AppManager
    
    @Environment(\.theme) private var theme
    
    @Dependency(\.accountStore) var accountStore: AccountStore
    @EnvironmentObject private var creditCardStore: CreditCardStore
    
    @StateObject private var viewModel: ViewModel = .init()
    
    public init() {}
    
    // MARK: -
    public var body: some View {
        VStack(spacing: 32) {
            HStack {
                Menu(
                    content: {
                        if let account = accountStore.selectedAccount {
                            NavigationButtonView(
                                route: .push,
                                destination: .account(.update(account: account))
                            ) {
                                Label(Word.Classic.edit, systemImage: "pencil")
                            }
                        }
                        
                        if let creditCard = creditCardStore.creditCards.first,
                           let uuid = creditCard.uuid {
                            Button(
                                role: .destructive,
                                action: {
                                    Task {
                                        if let account = accountStore.selectedAccount, let accountID = account._id {
                                            await creditCardStore.deleteCreditCard(accountID: accountID, cardID: uuid)
                                        }
                                    }
                                },
                                label: { Label(Word.CreditCard.deleteTitle, systemImage: "trash.fill") }
                            )
                        }
                        
                        Button(
                            role: .destructive,
                            action: { viewModel.isDeleting.toggle() },
                            label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                        )
                    },
                    label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.Text.primary)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    })
                
                Spacer()
                
                if !store.isCashFlowPro {
                    PremiumButtonView()
                }
                
                NavigationButtonView(route: .push, destination: .settings(.home)) {
                    Image("iconGear")
                        .renderingMode(.template)
                        .foregroundStyle(Color.Text.primary)
                }
            }
            
            ScrollView {
                VStack(spacing: 32) {
                    VStack(spacing: 16) {
                        LazyVGrid(columns: viewModel.columns, spacing: 16, content: {
                            NavigationButtonView(route: .push, destination: .account(.statistics)) {
                                Text("Stats")
                            }
                            .disabled(!store.isCashFlowPro)
                            .onTapGesture {
                                if !store.isCashFlowPro {
                                    alertManager.showPaywall(router: router)
                                }
                            }

                            NavigationButtonView(route: .push, destination: .budget(.list)) {
                                Text("Budgets")
                            }
                            .disabled(!store.isCashFlowPro)
                            .onTapGesture {
                                if !store.isCashFlowPro {
                                    alertManager.showPaywall(router: router)
                                }
                            }
                        })
                        
                        if let creditCard = creditCardStore.creditCards.first {
                            CreditCardView(creditCard: creditCard)
                        }
                    }
                    
                    Rectangle()
                        .frame(height: 120)
                        .opacity(0)
                } // Main VStack
            }
            .scrollIndicators(.hidden)
        }
        .padding(Padding.large)
        .background(Color.Background.bg50)
        .alert("account_detail_rename".localized, isPresented: $viewModel.isEditingAccountName, actions: {
            TextField("account_detail_new_name".localized, text: $viewModel.accountName)
            Button(action: { return }, label: { Text("word_cancel".localized) })
            Button(action: {
                Task {
                    if let account = accountStore.selectedAccount, let accountID = account._id {
                        await accountStore.updateAccount(accountID: accountID, body: .init(name: viewModel.accountName))
                    }
                }
            }, label: { Text("word_validate".localized) })
        })
        .alert("account_detail_delete_account".localized, isPresented: $viewModel.isDeleting, actions: {
            if let account = accountStore.selectedAccount {
                TextField(account.name, text: $viewModel.accountNameForDeleting)
                Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                Button(role: .destructive, action: {
                    if account.name == viewModel.accountNameForDeleting {
                        if let accountID = account._id {
                            Task {
                                await accountStore.deleteAccount(accountID: accountID)
                                accountStore.setNewAccount(account: accountStore.accounts.first)
                            }
                        }
                    }
                }, label: { Text("word_delete".localized) })
            }
        }, message: { Text("account_detail_delete_account_desc".localized) })
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    AccountDashboardScreen()
}
