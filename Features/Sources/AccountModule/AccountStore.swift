//
//  AccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 14/11/2024.
//

import Foundation
import Stores

public extension AccountStore {
    
    func cashFlowAmount(for month: Date) -> Double {
        let monthNum = month.month - 1
        if cashflow.isNotEmpty {
            return cashflow[monthNum]
        } else { return 0 }
    }
    
}
