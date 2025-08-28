//
//  SavingsAccountDetailScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 20/02/2024.
//

import SwiftUI
import Navigation
import StatsKit
import TheoKit
import DesignSystemModule
import Core
import TransactionModule
import EventModule
import TransferModule
import AccountModule
import Dependencies
import Stores

public struct SavingsAccountDetailScreen: View {
    
    // Builder    
    @EnvironmentObject private var themeManager: ThemeManager
    @EnvironmentObject private var transferStore: TransferStore
    @EnvironmentObject private var accountStore: AccountStore
    @Dependency(\.savingsAccountStore) private var savingsAccountStore
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var accountNameForDeleting: String = ""
    @State private var isDeleting: Bool = false
    
    // init
    public init() { }
    
    // MARK: - body
    public var body: some View {
        if let currentAccount = savingsAccountStore.currentAccount {
            VStack(spacing: 0) {
                NavigationBarWithMenu(title: currentAccount.name) {
                    NavigationButtonView(
                        route: .push,
                        destination: .savingsAccount(
                            .createTransaction(savingsAccount: currentAccount, transaction: nil)
                        )
                    ) {
                        Label(Word.Classic.add, systemImage: "plus")
                    }
                    NavigationButtonView(
                        route: .push,
                        destination: .transfer(.create(receiverAccount: savingsAccountStore.currentAccount))
                    ) {
                        Label(Word.Main.transfer, systemImage: "arrow.left.arrow.right")
                    }
                    NavigationButtonView(
                        route: .push,
                        destination: .savingsAccount(.update(savingsAccount: currentAccount))
                    ) {
                        Label(Word.Classic.edit, systemImage: "pencil")
                    }
                    Button(
                        role: .destructive,
                        action: { isDeleting.toggle() },
                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                    )
                }
                List {
                    SavingsAccountInfosView(savingsAccount: currentAccount)
                        .noDefaultStyle()
                        .padding(.horizontal, Padding.large)
                    
                    ForEach(transferStore.monthsOfTransfers, id: \.self) { month in
                        Section {
                            ForEach(transferStore.transfers) { transfer in
                                if Calendar.current.isDate(transfer.date, equalTo: month, toGranularity: .month) {
                                    NavigationButtonView(
                                        route: .push,
                                        destination: AppDestination.transaction(.detail(transaction: transfer))
                                    ) {
                                        if transfer.type == .transfer {
                                            TransferRowView(transfer: transfer)
                                        } else {
                                            TransactionRowView(transaction: transfer, isEditable: false)
                                        }
                                        EmptyView()
                                    }
                                    .padding(.bottom, Padding.medium)
                                    .padding(.horizontal, Padding.large)
                                }
                                
                            }
                            .noDefaultStyle()
                        } header: {
                            DetailOfTransferByMonth(
                                month: month,
                                amountOfSavings: transferStore.amountOfSavingsByMonth(month: month),
                                amountOfWithdrawal: transferStore.amountOfWithdrawalByMonth(month: month)
                            )
                            .padding(.horizontal, Padding.large)
                        }
                        .foregroundStyle(Color.label)
                    }
                } // End List
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
                .padding(.top, Padding.large)
            }
            .navigationBarBackButtonHidden(true)
            .background(TKDesignSystem.Colors.Background.Theme.bg50)
            .alert(
                "account_detail_delete_account".localized,
                isPresented: $isDeleting,
                actions: {
                    TextField(currentAccount.name, text: $accountNameForDeleting)
                    Button(role: .cancel, action: { return }, label: { Text("word_cancel".localized) })
                    Button(role: .destructive, action: {
                        if currentAccount.name == accountNameForDeleting {
                            if let accountID = currentAccount._id {
                                Task {
                                    await accountStore.deleteAccount(accountID: accountID)
                                    dismiss()
                                }
                            }
                        }
                    }, label: { Text(Word.Classic.delete) })
                }, message: { Text("account_detail_delete_account_desc".localized) }
            )
            .task {
                if let accountID = currentAccount._id {
                    transferStore.transfers = []
                    await transferStore.fetchTransfersWithPagination(accountID: accountID)
                }
            }
            .onAppear {
                EventService.sendEvent(key: EventKeys.accountSavingsDetailPage)
            }
        } else {
            EmptyView()
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailScreen()
        .environmentObject(ThemeManager.shared)
        .environmentObject(TransferStore.shared)
        .environmentObject(AccountStore.shared)
}
