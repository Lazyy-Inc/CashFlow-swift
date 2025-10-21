//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI
import DesignSystem
import Navigation
import TransactionModule

public struct SubscriptionsScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel = .init()
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
        ScrollView {
            VStack(spacing: Spacing.large) {
                TwoStatisticsRowView(
                    leftItem: .init(
                        value: viewModel.totalAnnualy.toCurrency(),
                        text: "subscription_total_yearly".localized),
                    rightItem: .init(
                        value: viewModel.totalMonthly.toCurrency(),
                        text: "subscription_total_monthly".localized
                    )
                )
                
                NavigationButtonView(
                    route: .push,
                    destination: .subscription(.list)
                ) {
                    ClassicRowView(text: "subscription_list_of_subscriptions".localized)
                }
                
                if !viewModel.subtitleToPay.isEmpty {
                    SubscriptionSectionView(
                        title: "subscription_coming_soon".localized,
                        subtitle: viewModel.subtitleToPay
                    ) {
                        ForEach(viewModel.subscriptionsToPay) { subscription in
                            NavigationButtonView(
                                route: .push,
                                destination: .subscription(.detail(subscriptionId: subscription.id))
                            ) {
                                SubscriptionRowView(subscription: subscription)
                            }
                        }
                    }
                }
                
                if !viewModel.subtitlePaid.isEmpty {
                    SubscriptionSectionView(
                        title: "subscription_past".localized,
                        subtitle: viewModel.subtitlePaid
                    ) {
                        ForEach(viewModel.transactionsPaidBySubscriptions) { transaction in
                            NavigationButtonView(
                                route: .push,
                                destination: .transaction(.detail(transaction: transaction))
                            ) {
                                TransactionRowView(transaction: transaction)
                            }
                        }
                    }
                }
            }
            .padding(Spacing.large)
        }
        .scrollIndicators(.hidden)
        .contentMargins(.bottom, Spacing.tabbar, for: .scrollContent)
        .background(Color.Background.bg50)
        .onLoadOrChange(of: viewModel.subscriptionStore.subscriptions) { _ in
            viewModel.getTotalAnnualy()
            viewModel.getTotalMonthly()
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionsScreen()
}
