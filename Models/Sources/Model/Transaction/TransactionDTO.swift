//
//  TransactionDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/04/2025.
//

import Foundation

public struct TransactionDTO: Codable, Sendable {
    public var id: Int?
    public var name: String?
    public var amount: Double?
    public var type: Int?
    public var dateISO: String?
    public var creationDate: String?
    public var categoryID: Int?
    public var subcategoryID: Int?
    public var note: String?

    public var isFromSubscription: Bool?
    public var isFromApplePay: Bool?
    public var nameFromApplePay: String?
    public var autoCat: Bool?

    public var senderAccountID: Int?
    public var receiverAccountID: Int?

    public var address: String?
    public var lat: Double?
    public var long: Double?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case amount
        case type
        case dateISO = "date"

        case creationDate
        case categoryID
        case subcategoryID
        case isFromSubscription
        case isFromApplePay
        case nameFromApplePay
        case senderAccountID
        case receiverAccountID
        case note
        case autoCat
        case address
        case lat
        case long
    }
}

// MARK: - Transaction
public extension TransactionDTO {
    
    /// Transaction init
    init(
        id: Int? = nil,
        name: String? = nil,
        amount: Double? = nil,
        type: Int? = nil,
        dateISO: String? = nil,
        creationDate: String? = nil,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil,
        isFromSubscription: Bool? = nil,
        isFromApplePay: Bool? = nil,
        nameFromApplePay: String? = nil,
        autoCat: Bool? = nil,
        note: String? = nil,
        address: String? = nil,
        lat: Double? = nil,
        long: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.dateISO = dateISO
        self.creationDate = creationDate
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
        self.autoCat = autoCat
        self.note = note
        self.address = address
        self.lat = lat
        self.long = long
    }
    
    /// Classic Transaction Body
    static func body(
        name: String,
        amount: Double,
        type: Int,
        dateISO: String,
        categoryID: Int? = nil,
        subcategoryID: Int? = nil
    ) -> TransactionDTO {
        return .init(
            name: name,
            amount: amount,
            type: type,
            dateISO: dateISO,
            categoryID: categoryID,
            subcategoryID: subcategoryID
        )
    }
    
}

// MARK: - Transfer
public extension TransactionDTO {
    
    /// Transfer init
    init(
        id: Int? = nil,
        amount: Double? = nil,
        dateISO: String? = nil,
        creationDate: String? = nil,
        senderAccountID: Int? = nil,
        receiverAccountID: Int? = nil,
        note: String? = nil
    ) {
        self.id = id
        self.amount = amount
        self.dateISO = dateISO
        self.creationDate = creationDate
        self.senderAccountID = senderAccountID
        self.receiverAccountID = receiverAccountID
        self.note = note
    }
    
}
