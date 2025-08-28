//
//  TransferDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/04/2025.
//

import SwiftUICore
import NavigationKit
import Models

public enum TransferDestination: DestinationItem {
    case create(receiverAccount: AccountModel? = nil)
}
