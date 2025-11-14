//
//  SubscriptionFrequency.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

public enum SubscriptionFrequency: Int, Codable, CaseIterable, Sendable, Nameable {
    case monthly = 0
    case yearly = 1
    case weekly = 2
    
    public var name: String {
        switch self {
        case .monthly: return "frequency_monthly"
        case .yearly: return "frequency_yearly"
        case .weekly: return "frequency_weekly"
        }
    }
}
