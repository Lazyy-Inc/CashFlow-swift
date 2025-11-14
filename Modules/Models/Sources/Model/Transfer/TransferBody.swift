//
//  TransferBody.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation

public struct TransferBody: Codable {
    public var amount: Double
    public var date: String
    
    public init(amount: Double, date: String) {
        self.amount = amount
        self.date = date
    }
}
