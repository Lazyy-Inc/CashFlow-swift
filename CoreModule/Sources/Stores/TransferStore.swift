//
//  TransferStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation

public final class TransferStore: ObservableObject {
    public static let shared = TransferStore()
    
    @Published public var transfers: [TransactionModel] = []
    
    public var monthsOfTransfers: [Date] {
        let calendar = Calendar.current
        
        let uniqueMonths = Set(transfers.map {
            calendar.dateComponents([.month, .year], from: $0.date)
        })
        
        return uniqueMonths.compactMap { calendar.date(from: $0) }.sorted(by: >)
    }
}
