//
//  TransactionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Dependencies

public final class TransactionStore: ObservableObject {
    public static let shared = TransactionStore()
    
    @Published public var transactions: [TransactionModel] = []
    
    @Published public var currentDateForFetch: Date = Date()
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
