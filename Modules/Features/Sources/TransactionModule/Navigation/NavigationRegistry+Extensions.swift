//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 21/01/2026.
//

import Foundation
import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerTransactionRoutes() {
        self.register(TransactionDestination.self) { destination in
            switch destination {
            case .list:
                AnyView(TransactionsScreen())
            case .specificList(let month, let type):
                AnyView(TransactionsForMonthScreen(selectedDate: month, type: type))
            case .create:
                AnyView(AddTransactionScreen())
            case .update(let transaction):
                AnyView(AddTransactionScreen(transaction: transaction))
            case .detail(let transactionId):
                AnyView(TransactionDetailsScreen(transactionId: transactionId))
            }
        }
    }
    
}
