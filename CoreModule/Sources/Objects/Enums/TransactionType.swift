//
//  TransactionType.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

public enum TransactionType: Int, CaseIterable {
    case expense = 0
    case income = 1
    case transfer = 2
    
    public var name: String {
        switch self {
        case .expense:  return Word.Classic.expense
        case .income:   return Word.Classic.income
        case .transfer: return Word.Main.transfer
        }
    }
}
