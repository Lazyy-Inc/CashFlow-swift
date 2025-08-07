//
//  TransactionDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

enum TransactionDestination: DestinationItem {
    case list
    case specificList(month: Date, type: TransactionType)
    case create
    case update(transaction: TransactionModel)
    case detail(transaction: TransactionModel)
}
