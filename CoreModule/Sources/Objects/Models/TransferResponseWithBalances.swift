//
//  TransferResponseWithBalances.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import Models

public struct TransferResponseWithBalances: Codable {
    public var senderNewBalance: Double?
    public var receiverNewBalance: Double?
    public var transaction: TransactionDTO?
    
    public init(
        senderNewBalance: Double? = nil,
        receiverNewBalance: Double? = nil,
        transaction: TransactionDTO? = nil
    ) {
        self.senderNewBalance = senderNewBalance
        self.receiverNewBalance = receiverNewBalance
        self.transaction = transaction
    }
}
