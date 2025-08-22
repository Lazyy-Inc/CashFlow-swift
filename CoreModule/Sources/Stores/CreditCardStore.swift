//
//  CreditCardStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 22/08/2025.
//

import Foundation

public final class CreditCardStore: ObservableObject {
    public static let shared = CreditCardStore()
    
    @Published public var creditCards: [CreditCardModel] = []
    @Published public var uuids: [UUID] = []
}

public extension CreditCardStore {
 
    func reset() {
        self.creditCards.removeAll()
        self.uuids.removeAll()
    }
    
}
