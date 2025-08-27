//
//  TransactionResponseWithBalance.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

public struct TransactionResponseWithBalance: Codable {
    public var newBalance: Double?
    public var transaction: TransactionDTO?
    
    public init(newBalance: Double? = nil, transaction: TransactionDTO? = nil) {
        self.newBalance = newBalance
        self.transaction = transaction
    }
}
