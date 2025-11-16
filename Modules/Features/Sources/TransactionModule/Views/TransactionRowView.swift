//
//  TransactionRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import Navigation
import TheoKit
import DesignSystem
import Core
import Dependencies
import Models
import Stores

public struct TransactionRowView: View {
    
    // MARK: Dependencies
    var transaction: TransactionModel
    var isEditable: Bool = true
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    // MARK: Environment
    @EnvironmentObject private var router: Router<AppDestination>
    
    var currentTransaction: TransactionModel {
        return transactionStore.transactions.first { $0.id == transaction.id } ?? transaction
    }
    
    // MARK: Init
    public init(transaction: TransactionModel, isEditable: Bool = true) {
        self.transaction = transaction
        self.isEditable = isEditable
    }
    
    // MARK: -
    public var body: some View {
        HStack(spacing: Spacing.medium) {
            CircleCategory(
                category: currentTransaction.category,
                subcategory: currentTransaction.subcategory,
                transaction: currentTransaction
            )
            
            FinancialItemTypeWithName(transaction)
            transactionAmountWithDate(transaction)
        }
        .geometryGroup()
        .padding(Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .contentShape(.contextMenuPreview, .rect(cornerRadius: CornerRadius.standard))
        .contextMenu {
            AsyncButton {
                if let accountId = accountStore.selectedAccount?._id {
                    await transactionStore.createTransaction(accountId: accountId, body: transaction.toDTO())
                }
            } label: {
                Label("transaction_swipe_action_duplicate".localized, systemImage: "plus.square.on.square")
            }
            
            Button {
                router.push(.transaction(.update(transaction: currentTransaction)))
            } label: {
                Label("transaction_swipe_action_edit".localized, systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                if transaction.type == .transfer {
                    AlertManager.shared.deleteTransfer(transfer: currentTransaction)
                } else {
                    AlertManager.shared.deleteTransaction(transaction: currentTransaction)
                }
            } label: {
                Label("transaction_swipe_action_delete".localized, systemImage: "trash")
            }
        } preview: {
            self
                .frame(width: UIScreen.main.bounds.width - 32)
        }
    }
}

// MARK: - Subviews
extension TransactionRowView {
    
    @ViewBuilder
    private func FinancialItemTypeWithName(_ transaction: TransactionModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(FinancialItemTypeString)
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                .fontWithLineHeight(.Body.small)
            
            Text(currentTransaction.nameDisplayed)
                .fontWithLineHeight(.Body.medium)
                .foregroundStyle(Color.text)
                .lineLimit(1)
        }
        .fullWidth(.leading)
    }
    
    @ViewBuilder
    private func transactionAmountWithDate(_ transaction: TransactionModel) -> some View {
        VStack(alignment: .trailing, spacing: Spacing.extraSmall) {
            Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
                .fontWithLineHeight(.Body.mediumBold)
                .foregroundStyle(currentTransaction.color)
                .lineLimit(1)
            
            Text(currentTransaction.date.withTemporality)
                .fontWithLineHeight(.Body.small)
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                .lineLimit(1)
        }
    }
    
}

extension TransactionRowView {
    
    var FinancialItemTypeString: String {
        if currentTransaction.isFromSubscription == true {
            return Word.Main.subscription
        } else {
            return currentTransaction.type.name
        }
    }
    
}

// MARK: - Preview
#Preview {
    Group {
        TransactionRowView(transaction: .mockClassicTransaction)
        TransactionRowView(transaction: .mockClassicTransaction)
    }
    .padding()
    .background(Color.Background.bg50)
}
