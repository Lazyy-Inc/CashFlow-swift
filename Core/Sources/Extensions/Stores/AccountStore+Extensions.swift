//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 06/09/2025.
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
