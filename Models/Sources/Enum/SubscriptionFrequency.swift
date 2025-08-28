//
//  SubscriptionFrequency.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

public enum SubscriptionFrequency: Int, Codable, CaseIterable, Sendable {
    case monthly = 0
    case yearly = 1
    case weekly = 2
}
