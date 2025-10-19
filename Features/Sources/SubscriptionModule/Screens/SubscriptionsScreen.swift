//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI
import DesignSystem
import Navigation

public struct SubscriptionsScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel = .init()
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                TwoStatisticsRowView(
                    leftItem: .init(value: viewModel.totalAnnualy.toCurrency(), text: "subscription_total_yearly".localized),
                    rightItem: .init(value: viewModel.totalMonthly.toCurrency(), text: "subscription_total_monthly".localized)
                )
                
                VStack(spacing: Spacing.medium) {
                    ForEach(viewModel.subscriptionStore.subscriptions) { subscription in
                        NavigationButtonView(
                            route: .push,
                            destination: .subscription(.detail(subscriptionId: subscription.id))
                        ) {
                            SubscriptionRowView(subscription: subscription)
                        }
                    }
                }
            }
            .padding(Spacing.large)
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionsScreen()
}
