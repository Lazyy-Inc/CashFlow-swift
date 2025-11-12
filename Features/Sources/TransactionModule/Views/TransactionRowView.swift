//
//  TransactionRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 17/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import SwipeActions
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
        SwipeView(
            label: {
                HStack(spacing: Spacing.medium) {
                    CircleCategory(
                        category: currentTransaction.category,
                        subcategory: currentTransaction.subcategory,
                        transaction: currentTransaction
                    )
                    
                    transactionTypeWithName(transaction)
                    transactionAmountWithDate(transaction)
                }
                .geometryGroup()
                .padding(Padding.medium)
                .roundedRectangleBorder(
                    TKDesignSystem.Colors.Background.Theme.bg100,
                    radius: 16,
                    lineWidth: 1,
                    strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
                )
            },
            leadingActions: { context in
                SwipeAction {
                    Task {
                        if let accountId = accountStore.selectedAccount?._id {
                            await transactionStore.createTransaction(accountId: accountId, body: transaction.toDTO())
                        }
                        context.state.wrappedValue = .closed
                    }
                        
                } label: { _ in
                    swipeActionLabel(icon: "plus.square.on.square", text: "transaction_swipe_action_duplicate".localized)
                } background: { _ in
                    Color.blue
                }
            },
            trailingActions: { context in
                if isEditable {
                    SwipeAction(action: {
                        router.push(.transaction(.update(transaction: currentTransaction)))
                        context.state.wrappedValue = .closed
                    }, label: { _ in
                        swipeActionLabel(icon: "pencil", text: "transaction_swipe_action_edit".localized)
                    }, background: { _ in
                        Color.blue
                    })
                }
                
                SwipeAction(action: {
                    if transaction.type == .transfer {
                        AlertManager.shared.deleteTransfer(transfer: currentTransaction)
                    } else {
                        AlertManager.shared.deleteTransaction(transaction: currentTransaction)
                    }
                    context.state.wrappedValue = .closed
                }, label: { _ in
                    swipeActionLabel(icon: "trash", text: "transaction_swipe_action_delete".localized)
                }, background: { _ in
                    Color.Error.error400
                })
            })
        .swipeActionsStyle(.cascade)
        .swipeActionWidth(90)
        .swipeActionCornerRadius(16)
        .swipeMinimumDistance(40)
    } // body
} // struct

// MARK: - Subviews
extension TransactionRowView {
    
    @ViewBuilder
    private func transactionTypeWithName(_ transaction: TransactionModel) -> some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(transactionTypeString)
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
    
    @ViewBuilder
    private func swipeActionLabel(icon: String, text: String) -> some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20, weight: .semibold, design: .rounded))
            
            Text(text)
                .fontWithLineHeight(.Label.large)
        }
        .foregroundStyle(Color.white)
    }
    
}

extension TransactionRowView {
    
    var transactionTypeString: String {
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
