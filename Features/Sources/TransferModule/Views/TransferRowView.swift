//
//  TransferRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 23/11/2023.
//

import SwiftUI
import Core
import Dependencies
import Models
import Stores
import DesignSystem

public enum TransferRowLocation {
    case successfulSheet, savingsAccount
}

public struct TransferRowView: View {

    // MARK: Dependencies
    var transfer: TransactionModel
    var location: TransferRowLocation = .savingsAccount
    @Dependency(\.savingsAccountStore) private var savingsAccountStore
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    // MARK: Environments
    @EnvironmentObject private var transferStore: TransferStore
        
    // MARK: States
    @State private var isDeleting: Bool = false
    @State private var cancelDeleting: Bool = false

    // MARK: Init
    public init(
        transfer: TransactionModel,
        location: TransferRowLocation = .savingsAccount
    ) {
        self.transfer = transfer
        self.location = location
    }
    
    var isSender: Bool {
        switch location {
        case .successfulSheet:
            return accountStore.selectedAccount?._id == transfer.senderAccount?._id
        case .savingsAccount:
            return savingsAccountStore.currentAccount?._id == transfer.senderAccount?._id
        }
    }
    
    // MARK: - View
    public var body: some View {
        HStack {
            Circle()
                .foregroundStyle(Color.Background.bg200)
                .frame(width: 50)
                .overlay {
                    Circle()
                        .foregroundStyle(isSender ? Color.Error.error400 : Color.primary500)
                        .shadow(radius: 4, y: 4)
                        .frame(width: 34)
                    
                    Image(systemName: isSender ? "antenna.radiowaves.left.and.right" : "tray.fill")
                        .font(.system(size: 14, weight: .semibold, design: .rounded))
                        .foregroundStyle(Color(uiColor: .systemBackground))
                }
            
            VStack(alignment: .leading, spacing: 5) {
                Text(Word.Main.transfer)
                    .foregroundStyle(Color.customGray)
                    .font(Font.mediumSmall())
                Text(isSender ? Word.Classic.sent : Word.Classic.received)
                    .font(.semiBoldText18())
                    .foregroundStyle(Color.text)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 5) {
                Text("\(isSender ? "-" : "+") \((transfer.amount).toCurrency())")
                    .font(.semiBoldText16())
                    .foregroundStyle(isSender ? Color.Error.error400 : Color.primary500)
                    .lineLimit(1)
                Text(transfer.date.formatted(date: .numeric, time: .omitted))
                    .font(Font.mediumSmall())
                    .foregroundStyle(Color.customGray)
                    .lineLimit(1)
            }
        }
        .geometryGroup()
        .padding(12)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Background.bg100)
        }
        .contentShape(.contextMenuPreview, .rect(cornerRadius: CornerRadius.standard))
        .contextMenu {
            Button(role: .destructive) {
                withAnimation { isDeleting.toggle() }
            } label: {
                Label(Word.Classic.delete, systemImage: "trash")
            }
        } preview: {
            self
                .frame(width: UIScreen.main.bounds.width - 32)
        }
        .alert("transfer_detail_delete_transac".localized, isPresented: $isDeleting, actions: {
            Button(role: .cancel, action: { cancelDeleting.toggle(); return }, label: { Text("word_cancel".localized) })
            Button(role: .destructive, action: {
                Task {
                    await transferStore.deleteTransfer(transferID: transfer.id)
                }
            }, label: { Text("word_delete".localized) })
        }, message: {
            Text((transfer.amount) < 0 ? "transfer_detail_alert_if_expense".localized : "transfer_detail_alert_if_income".localized)
        })
    }
}

// MARK: - Preview
#Preview {
    TransferRowView(transfer: .mockTransferTransaction)
}
