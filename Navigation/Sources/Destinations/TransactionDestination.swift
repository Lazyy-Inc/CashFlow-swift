//
//  TransactionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import Foundation
import NavigationKit
import Models

public enum TransactionDestination: DestinationItem {
    case list
    case specificList(month: Date, type: TransactionType)
    case create
    case update(transaction: TransactionModel)
    case detail(transactionId: Int)
}
