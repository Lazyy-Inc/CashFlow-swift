//
//  HomeScreenSubscriptionView.swift
//  CashFlow
//
//  Created by Theo Sementa on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI
import Navigation
import TheoKit
import DesignSystemModule
import PreferenceModule
import CoreModule
import Dependencies
import SubscriptionModule

struct HomeScreenSubscriptionView: View {
    
    // Environment
    @Dependency(\.subscriptionStore) private var subscriptionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.standard) {
            HomeScreenComponentHeaderView(type: .subscription)
            
            if !subscriptionStore.subscriptions.isEmpty {
                VStack(spacing: Spacing.medium) {
                    ForEach(subscriptionStore.subscriptions.prefix(preferencesDisplayHome.subscription_value)) { subscription in
                        NavigationButtonView(
                            route: .push,
                            destination: AppDestination.subscription(.detail(subscriptionId: subscription.id))
                        ) {
                            SubscriptionRowView(subscription: subscription)
                        }
                    }
                }
            } else {
                CustomEmptyView(
                    type: .empty(.subscriptions(.home)),
                    isDisplayed: true
                )
            }
        }
        .isDisplayed(preferencesDisplayHome.subscription_isDisplayed)
    } // body
} // struct

// MARK: - Preview
#Preview {
    HomeScreenSubscriptionView()
}
