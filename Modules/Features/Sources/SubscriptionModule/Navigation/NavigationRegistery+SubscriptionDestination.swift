//
//  NavigationRegistery+SubscriptionDestination.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerSubscriptionRoutes() {
        self.register(SubscriptionDestination.self) { destination in
            switch destination {
            case .list:
                AnyView(SubscriptionsListScreen())
            case .create:
                AnyView(AddSubscriptionScreen())
            case .update(let subscription):
                AnyView(AddSubscriptionScreen(subscription: subscription))
            case .detail(let subscriptionId):
                AnyView(SubscriptionDetailsScreen(subscriptionId: subscriptionId))
            }
        }
    }
    
}
