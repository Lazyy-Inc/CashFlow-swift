//
//  SavingsPlanDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import NavigationKit

public enum SavingsPlanDestination: DestinationItem {
    case list
    case create
    case update(savingsPlan: SavingsPlanModel)
    case detail(savingsPlan: SavingsPlanModel)
}
