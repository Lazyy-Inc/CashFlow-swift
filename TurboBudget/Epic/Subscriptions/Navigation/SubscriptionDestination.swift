//
//  SubscriptionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum SubscriptionDestination: DestinationItem {
    case list
    case create
    case update(subscription: SubscriptionModel)
    case detail(subscriptionId: Int)    
}
