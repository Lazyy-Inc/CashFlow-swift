//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 14/11/2025.
//

import SwiftUI
import Models
import Core
import Navigation
import AlertKit
import Dependencies

public struct FinancialItemRowView: View {
    
    // MARK: Dependencies
    let financialItem: FinancialItemProtocol
    let isLastDateToDisplay: Bool
    let isEditable: Bool
    let isTransfer: Bool
    @Dependency(\.accountStore) private var accountStore
    @Dependency(\.transactionStore) private var transactionStore
    @Dependency(\.savingsAccountStore) private var savingsAccountStore
    
    // MARK: Environment
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: Init
    public init(
        financialItem: FinancialItemProtocol,
        isLastDateToDisplay: Bool = false,
        isTransfer: Bool = false,
        isEditable: Bool = true
    ) {
        self.financialItem = financialItem
        self.isLastDateToDisplay = isLastDateToDisplay
        self.isTransfer = isTransfer
        self.isEditable = isEditable
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.medium) {
            CircleColoredWithIconView(
                circleColor: circleColor,
                icon: financialIcon,
                iconColor: .white
            )
            
            financialItemTypeWithNameView
            financialItemAmountWithDateView
        }
        .geometryGroup()
        .padding(Padding.medium)
        .roundedBackground(.classic)
        .contentShape(.contextMenuPreview, .rect(cornerRadius: CornerRadius.standard))
        .contextMenu {
            contextMenuButtonsView
        } preview: {
            self
                .frame(width: UIScreen.main.bounds.width - 32)
        }
    }
}

// MARK: - Utils
extension FinancialItemRowView {
    
    private var isSender: Bool {
        if let accountPrensented = savingsAccountStore.currentAccount, isTransfer {
            return financialItem.senderAccount?.id == accountPrensented.id
        } else if let selectedAccount = accountStore.selectedAccount {
            return financialItem.senderAccount?.id == selectedAccount.id
        } else {
            return false
        }
    }
    
    private var nameDisplayed: String {
        switch financialItem.type {
        case .expense, .income:
            return financialItem.name
        case .transfer:
            guard let senderAccount = financialItem.senderAccount,
                  let receiverAccount = financialItem.receiverAccount
            else { return "" }
            
            if isSender {
                let receiverAccountName = receiverAccount.name
                return [Word.Classic.sent, Word.Preposition.to, receiverAccountName].joined(separator: " ")
            } else {
                let senderAccountName = senderAccount.name
                return [Word.Classic.received, Word.Preposition.from, senderAccountName].joined(separator: " ")
            }
        }
    }
    
    private var financialDate: Date {
        if let subscription = financialItem as? SubscriptionModel {
            if isLastDateToDisplay, let lastDate = subscription.lastSubscriptionDate {
                return lastDate
            } else {
                return subscription.frequencyDate
            }
        } else {
            return financialItem.date
        }
    }
    
    private var financialSymbol: String {
        switch financialItem.type {
        case .expense:
            return "-"
        case .income:
            return "+"
        case .transfer:
            if isSender { return "-" } else { return "+" }
        }
    }
    
    private var financialColor: Color {
        switch financialItem.type {
        case .expense:
            return .Red.r500
        case .income:
            return .Primary.p500
        case .transfer:
            return isSender ? .Red.r500 : .Primary.p500
        }
    }
    
    private var circleColor: Color {
        switch financialItem.type {
        case .expense, .income:
            return financialItem.category?.color ?? .gray
        case .transfer:
            return isSender ? .Red.r500 : .Primary.p500
        }
    }
    
    private var financialIcon: String {
        switch financialItem.type {
        case .expense, .income:
            if let subcategory = financialItem.subcategory {
                return subcategory.icon
            } else if let category = financialItem.category {
                return category.icon
            } else {
                return "iconQuestionFile"
            }
        case .transfer:
            return isSender ? "iconSend" : "iconHandCoins"
        }
    }
    
}

// MARK: - Subviews
extension FinancialItemRowView {
    
    @ViewBuilder
    private var financialItemTypeWithNameView: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(financialItem.type.name)
                .foregroundStyle(Color.Background.bg600)
                .font(.Body.small)
            
            Text(nameDisplayed)
                .font(.Body.medium, color: .Text.primary)
                .lineLimit(1)
        }
        .fullWidth(.leading)
    }
    
    @ViewBuilder
    private var financialItemAmountWithDateView: some View {
        VStack(alignment: .trailing, spacing: Spacing.extraSmall) {
            Text("\(financialSymbol) \(financialItem.amount.toCurrency())")
                .font(.Body.mediumBold, color: financialColor)
                .lineLimit(1)
            
            Text(financialDate.withTemporality)
                .font(.Body.small, color: .Background.bg600)
                .lineLimit(1)
        }
    }
    
    @ViewBuilder
    private var contextMenuButtonsView: some View {
        if let transaction = financialItem as? TransactionModel {
            contextMenuButtonsView(transaction: transaction)
        } else if let subscription = financialItem as? SubscriptionModel {
            contextMenuButtonsView(subscription: subscription)
        }
    }
    
    @ViewBuilder
    private func contextMenuButtonsView(transaction: TransactionModel) -> some View {
        if isTransfer == false {
            AsyncButton {
                if let accountId = accountStore.selectedAccount?._id {
                    await transactionStore.createTransaction(accountId: accountId, body: transaction.toDTO())
                }
            } label: {
                Label("transaction_swipe_action_duplicate".localized, systemImage: "plus.square.on.square")
            }
        }
        
        if isEditable {
            Button {
                router.push(.transaction(.update(transaction: transaction)))
            } label: {
                Label("transaction_swipe_action_edit".localized, systemImage: "pencil")
            }
        }
        
        Button(role: .destructive) {
            if transaction.type == .transfer {
                AlertManager.shared.deleteTransfer(transfer: transaction)
            } else {
                AlertManager.shared.deleteTransaction(transaction: transaction)
            }
        } label: {
            Label("transaction_swipe_action_delete".localized, systemImage: "trash")
        }
    }
    
    @ViewBuilder
    private func contextMenuButtonsView(subscription: SubscriptionModel) -> some View {
        if isEditable {
            Button {
                router.push(.subscription(.update(subscription: subscription)))
            } label: {
                Label(Word.Classic.edit, systemImage: "pencil")
            }
        }
        
        Button(role: .destructive) {
            AlertManager.shared.deleteSubscription(subscription: subscription)
        } label: {
            Label(Word.Classic.delete, systemImage: "trash")
        }
    }
    
}

// MARK: - Preview
#Preview {
    VStack(spacing: Spacing.large) {
        FinancialItemRowView(financialItem: TransactionModel.mockClassicTransaction)
        FinancialItemRowView(financialItem: TransactionModel.mockTransferTransaction)
        FinancialItemRowView(financialItem: SubscriptionModel.mockClassicSubscriptionExpense)
    }
    .padding(Spacing.large)
}
