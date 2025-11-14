//
//  SavingsAccountStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import Foundation
import Dependencies
import Models

@Observable
public final class SavingsAccountStore {
    public static let shared = SavingsAccountStore()
    
    public var currentAccount: AccountModel?    
}

// MARK: - Dependencies
extension SavingsAccountStore: DependencyKey {
    public static var liveValue: SavingsAccountStore = .shared
}

public extension DependencyValues {
    var savingsAccountStore: SavingsAccountStore {
        get { self[SavingsAccountStore.self] }
        set { self[SavingsAccountStore.self] = newValue }
    }
}
