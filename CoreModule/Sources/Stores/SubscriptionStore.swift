//
//  SubscriptionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies

@Observable
public final class SubscriptionStore {
    public static let shared = SubscriptionStore()
    
    public var subscriptions: [SubscriptionModel] = []
}

extension SubscriptionStore: DependencyKey {
    public static var liveValue: SubscriptionStore = .shared
}

public extension DependencyValues {
    var subscriptionStore: SubscriptionStore {
        get { self[SubscriptionStore.self] }
        set { self[SubscriptionStore.self] = newValue }
    }
}

