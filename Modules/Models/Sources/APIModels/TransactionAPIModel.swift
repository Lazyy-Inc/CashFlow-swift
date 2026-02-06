//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 13/01/2026.
//

import Foundation

public struct TransactionAPIModel: APIModel {
    public let id: Int?
    
    public let name: String?
    public let amount: Double?
    public let type: Int?
    public let date: String?
    
    public let categoryID: Int?
    public let subcategoryID: Int?
    
    public let repartitionType: String?

    public let isFromSubscription: Bool?
    public let isFromApplePay: Bool?
    public let nameFromApplePay: String?
    public let autoCat: Bool?

    public let senderAccountID: Int?
    public let receiverAccountID: Int?

    public let address: String?
    public let lat: Double?
    public let long: Double?
  
    public let accountId: Int? // Only for transactions with ApplePay
    
    init(
        id: Int?,
        name: String?,
        amount: Double?,
        type: Int?,
        date: String?,
        categoryID: Int?,
        subcategoryID: Int?,
        repartitionType: String?,
        isFromSubscription: Bool?,
        isFromApplePay: Bool?,
        nameFromApplePay: String?,
        autoCat: Bool?,
        senderAccountID: Int?,
        receiverAccountID: Int?,
        address: String?,
        lat: Double?,
        long: Double?,
        accountId: Int?
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.type = type
        self.date = date
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
        self.repartitionType = repartitionType
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
        self.autoCat = autoCat
        self.senderAccountID = senderAccountID
        self.receiverAccountID = receiverAccountID
        self.address = address
        self.lat = lat
        self.long = long
        self.accountId = accountId
    }
}

// MARK: - Transaction
public extension TransactionAPIModel {
    
//    func toUIModel() -> TransactionUIModel {
//        
//    }
    
}

// MARK: - Transfer
public extension TransactionAPIModel {
    
//    /// Transfer init
//    init(
//        id: Int? = nil,
//        amount: Double? = nil,
//        date: String? = nil,
//        senderAccountID: Int? = nil,
//        receiverAccountID: Int? = nil
//    ) {
//        self.id = id
//        self.amount = amount
//        self.date = date
//        self.senderAccountID = senderAccountID
//        self.receiverAccountID = receiverAccountID
//    }
    
}
