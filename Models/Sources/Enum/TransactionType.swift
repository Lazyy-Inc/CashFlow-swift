//
//  TransactionType.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

public enum TransactionType: Int, CaseIterable, Sendable {
    case expense = 0
    case income = 1
    case transfer = 2
}
