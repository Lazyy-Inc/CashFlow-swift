//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI
import DesignSystem
import Models
import Navigation

struct SubscriptionSectionView<Content: View>: View {
    
    // MARK: Dependencies
    let title: String
    let subtitle: String
    let content: () -> Content
    
    init(title: String, subtitle: String, content: @escaping () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content
    }
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .fontWithLineHeight(.Body.large)
                    .foregroundStyle(Color.text)
                Text(subtitle)
                    .fontWithLineHeight(.Body.small)
                    .foregroundStyle(Color.Background.bg600)
            }
            
            VStack(spacing: Spacing.small) {
                content()
            }
        }
    }
}

// MARK: - Preview
#Preview {
    SubscriptionSectionView(
        title: "A venir",
        subtitle: "Il te reste 36,23 € à payer"
    ) {
        Group {
            let subscriptions = [SubscriptionModel.mockClassicSubscriptionExpense]
            ForEach(subscriptions) { subscription in
                NavigationButtonView(
                    route: .push,
                    destination: .subscription(.detail(subscriptionId: subscription.id))
                ) {
                    FinancialItemRowView(financialItem: subscription)
                }
            }
        }
    }
}
