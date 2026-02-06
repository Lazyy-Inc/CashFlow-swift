//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation
import Dependencies

extension TransactionStore: DependencyKey {
    public static var liveValue: TransactionStore = .shared
}

public extension DependencyValues {
    var transactionStore: TransactionStore {
        get { self[TransactionStore.self] }
        set { self[TransactionStore.self] = newValue }
    }
}
