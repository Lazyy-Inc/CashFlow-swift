//
//  SavingsAccountDetailScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 20/02/2024.
//

import SwiftUI
import Navigation
import DesignSystem
import Core
import TransactionModule
import Events
import TransferModule
import AccountModule
import Dependencies
import Stores

public struct SavingsAccountDetailScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.accountStore) var accountStore: AccountStore
    @Dependency(\.transferStore) var transferStore: TransferStore
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
                                        destination: .transaction(.detail(transactionId: transfer.id))
                                    ) {
                                        FinancialItemRowView(financialItem: transfer, isTransfer: true, isEditable: false)
                                    }
                                    .buttonStyle(.plain)
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
            .background(Color.Background.bg50)
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
                // EventService.sendEvent(key: EventKeys.accountSavingsDetailPage)
            }
        } else {
            EmptyView()
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountDetailScreen()
}
