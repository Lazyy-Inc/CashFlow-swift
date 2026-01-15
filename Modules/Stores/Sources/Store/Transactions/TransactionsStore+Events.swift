//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation
import Events
import Models

public extension EventService {
    
    @MainActor
    private static func sendFinancialItemTypeEvent(type: FinancialItemType) {
        if type == .expense {
            // EventService.sendEvent(key: EventKeys.transactionExpenseCreated)
        } else if type == .income {
            // EventService.sendEvent(key: EventKeys.transactionIncomeCreated)
        }
    }
    
    @MainActor
    private static func sendApplePayEvent(isFromApplePay: Bool) {
        if isFromApplePay {
            // EventService.sendEvent(key: EventKeys.transactionCreatedApplePay)
        }
    }
    
    @MainActor
    static func sendForTransactionCreated(transaction: TransactionModel) {
        // EventService.sendEvent(key: EventKeys.transactionCreated)
//        EventService.sendFinancialItemTypeEvent(type: transaction.type)
//        EventService.sendApplePayEvent(isFromApplePay: transaction.isFromApplePay)
    }
    
}
