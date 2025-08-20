//
//  StatisticData.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/12/2024.
//

import Foundation

public struct StatisticData: Identifiable {
    public let id: UUID = UUID()
    public let text: String
    public let value: Double
    
    public init(text: String, value: Double) {
        self.text = text
        self.value = value
    }
}
