//
//  SubscriptionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import NavigationKit
import Models

public enum SubscriptionDestination: DestinationItem {
    case list
    case create
    case update(subscription: SubscriptionModel)
    case detail(subscriptionId: Int)    
}
