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
                
                if !viewModel.subtitleToPay.isEmpty {
                    SubscriptionSectionView(
                        title: "subscription_coming_soon".localized,
                        subtitle: viewModel.subtitleToPay,
                        subscriptions: viewModel.subscriptionsToPay
                    )
                }
                
                if !viewModel.subtitlePaid.isEmpty {
                    SubscriptionSectionView(
                        title: "subscription_past".localized,
                        subtitle: viewModel.subtitlePaid,
                        subscriptions: viewModel.subscriptionsPaid
                    )
                }
            }
            .padding(Spacing.large)
        }
        .background(Color.Background.bg50)
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionsScreen()
}
