//
//  TransactionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Dependencies

@Observable
public final class TransactionStore {
    public static let shared = TransactionStore()
    
    public var transactions: [TransactionModel] = []
    
    public var currentDateForFetch: Date = Date()
    public var dateFetched: [Date] = []
}

extension TransactionStore: DependencyKey {
    public static var liveValue: TransactionStore = .shared
}

public extension DependencyValues {
    var transactionStore: TransactionStore {
        get { self[TransactionStore.self] }
        set { self[TransactionStore.self] = newValue }
    }
}
