//
//  AccountDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import NavigationKit
import Models

public enum AccountDestination: DestinationItem {
    case create
    case update(account: AccountModel)
    case dashboard
    case statistics
}
