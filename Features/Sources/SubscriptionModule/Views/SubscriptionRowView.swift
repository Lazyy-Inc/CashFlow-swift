//
//  SubscriptionRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/07/2023.
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

public struct SubscriptionRowView: View {
    
    // MARK: Dependencies
    var subscription: SubscriptionModel
    let isLastDateToDisplay: Bool
    @Dependency(\.subscriptionStore) private var subscriptionStore
    
    // MARK: Enviroments
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: Init
    public init(subscription: SubscriptionModel, isLastDateToDisplay: Bool = false) {
        self.subscription = subscription
        self.isLastDateToDisplay = isLastDateToDisplay
    }
    
    var currentSubscription: SubscriptionModel {
        return subscriptionStore.subscriptions.first { $0.id == subscription.id } ?? subscription
    }
    
    var dateToDisplay: String {
        if isLastDateToDisplay, let lastDate = subscription.lastSubscriptionDate {
            lastDate.withTemporality
        } else {
            subscription.frequencyDate.withTemporality
        }
    }
    
    // MARK: -
    public var body: some View {
        HStack(spacing: Spacing.medium) {
            CircleCategory(
                category: subscription.category,
                subcategory: subscription.subcategory
            )
            
            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Text(Word.Main.subscription)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .font(TKDesignSystem.Fonts.Body.small)
                
                Text(subscription.name)
                    .font(TKDesignSystem.Fonts.Body.medium)
                    .foregroundStyle(Color.text)
                    .lineLimit(1)
            }
            .fullWidth(.leading)
                                
            VStack(alignment: .trailing, spacing: Spacing.extraSmall) {
                Text("\(subscription.symbol) \(subscription.amount.toCurrency())")
                    .font(TKDesignSystem.Fonts.Body.mediumBold)
                    .foregroundStyle(subscription.color)
                    .lineLimit(1)
                
                Text(dateToDisplay)
                    .font(TKDesignSystem.Fonts.Body.small)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .lineLimit(1)
            }
        }
        .geometryGroup()
        .padding(Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: 16,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
        .contentShape(.contextMenuPreview, .rect(cornerRadius: CornerRadius.standard))
        .contextMenu {
            Button {
                router.push(.subscription(.update(subscription: subscription)))
            } label: {
                Label(Word.Classic.edit, systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                AlertManager.shared.deleteSubscription(subscription: subscription)
            } label: {
                Label(Word.Classic.delete, systemImage: "trash")
            }
        } preview: {
            self
                .frame(width: UIScreen.main.bounds.width - 32)
        }
    }
}

// MARK: - Preview
#Preview {
    SubscriptionRowView(subscription: .mockClassicSubscriptionExpense)
}
