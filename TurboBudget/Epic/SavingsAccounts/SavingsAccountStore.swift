//
//  SavingsAccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import NetworkKit
import CoreModule

public final class SavingsAccountStore: ObservableObject {
    
    @Published public var currentAccount: AccountModel
    
    public init(currentAccount: AccountModel) {
        self.currentAccount = currentAccount
    }
    
}
