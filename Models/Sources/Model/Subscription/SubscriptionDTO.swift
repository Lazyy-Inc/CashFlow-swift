//
//  SubscriptionDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/04/2025.
//

import Foundation
import NetworkKit

public struct SubscriptionDTO: Codable {
    public var id: Int?
    public var name: String?
    public var amount: Double?
    public var typeNum: Int?
    public var frequencyNum: Int? // SubscriptionFrequency
    public var frequencyDate: String?
    public var categoryID: Int?
    public var subcategoryID: Int?
    public var firstSubscriptionDate: String?
    public var transactions: [TransactionDTO]?

    // Initialiseur
    public init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        typeNum: Int? = nil,
        frequencyNum: Int? = nil,
        frequencyDate: String? = nil,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil,
        firstSubscriptionDate: String? = nil,
        transactions: [TransactionDTO]? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.typeNum = typeNum
        self.frequencyNum = frequencyNum
        self.frequencyDate = frequencyDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.firstSubscriptionDate = firstSubscriptionDate
        self.transactions = transactions
    }
    
    /// Body
    public init(
        name: String,
        amount: Double,
        type: TransactionType,
        frequency: SubscriptionFrequency,
        frequencyDate: String,
        categoryID: Int,
        subcategoryID: Int? = nil
    ) {
        self.name = name
        self.amount = amount
        self.typeNum = type.rawValue
        self.frequencyNum = frequency.rawValue
        self.frequencyDate = frequencyDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount, frequencyDate, categoryID, subcategoryID, transactions
        case typeNum = "type"
        case frequencyNum = "frequency"
        case firstSubscriptionDate
    }
}
