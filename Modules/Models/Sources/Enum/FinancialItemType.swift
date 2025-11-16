//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 14/11/2025.
//

import Foundation

public enum FinancialItemType: Int, CaseIterable, Sendable {
    case expense = 0
    case income = 1
    case transfer = 2
}
