//
//  TransactionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation

public final class TransactionStore: ObservableObject {
    public static let shared = TransactionStore()
    
    @Published public var transactions: [TransactionModel] = []
    
    @Published public var currentDateForFetch: Date = Date()
    public var dateFetched: [Date] = []
}
