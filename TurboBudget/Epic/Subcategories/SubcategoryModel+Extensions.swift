//
//  SubcategoryModel+Extensions.swift
//  CashFlow
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import CoreModule

public extension SubcategoryModel {
    
    var transactionsFiltered: [TransactionModel] {
        return self.transactions
            .filter { Calendar.current.isDate($0.date, equalTo: FilterManager.shared.date, toGranularity: .month) }
    }
    
}
