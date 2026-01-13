//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUI

public struct TransactionModel: Identifiable, Equatable, Hashable, Sendable {
    public var id: Int
    public var name: String
    public var amount: Double
    public var date: Date
    public var creationDate: Date?
    public var category: CategoryModel?
    public var subcategory: SubcategoryModel?
    public var repartitionType: RepartitionType?
    public var note: String?

    public var isFromSubscription: Bool
    public var isFromApplePay: Bool
    public var nameFromApplePay: String?
    public var autoCat: Bool?

    public var senderAccount: AccountModel?
    public var receiverAccount: AccountModel?

    public var address: String?
    public var lat: Double?
    public var long: Double?
    
    public init(
        id: Int,
        name: String,
        amount: Double,
        date: Date,
        creationDate: Date? = nil,
        category: CategoryModel? = nil,
        subcategory: SubcategoryModel? = nil,
        repartitionType: RepartitionType? = nil,
        note: String? = nil,
        isFromSubscription: Bool = false,
        isFromApplePay: Bool = false,
        nameFromApplePay: String? = nil,
        autoCat: Bool? = nil,
        senderAccount: AccountModel? = nil,
        receiverAccount: AccountModel? = nil,
        address: String? = nil,
        lat: Double? = nil,
        long: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.amount = amount
        self.date = date
        self.creationDate = creationDate
        self.category = category
        self.subcategory = subcategory
        self.repartitionType = repartitionType
        self.note = note
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
        self.autoCat = autoCat
        self.senderAccount = senderAccount
        self.receiverAccount = receiverAccount
        self.address = address
        self.lat = lat
        self.long = long
    }
}

extension TransactionModel: FinancialItemProtocol {
    
    public var searchableText: String {
        return name
    }
    
    public var type: FinancialItemType {
        if self.senderAccount != nil && self.receiverAccount != nil {
            return .transfer
        }
        
        if category?.isIncome == true {
            return .income
        } else {
            return .expense
        }
    }
    
}

public extension TransactionModel {
    
    func toDTO() -> TransactionDTO {
        return .init(
            name: self.name,
            amount: self.amount,
            type: self.type.rawValue,
            dateISO: self.date.ISO8601Format(),
            categoryID: self.category?.id,
            subcategoryID: self.subcategory?.id,
            repartitionType: self.repartitionType?.rawValue,
            senderAccountID: Int(self.senderAccount?.id ?? ""),
            receiverAccountID: Int(self.receiverAccount?.id ?? ""),
            address: self.address,
            lat: self.lat,
            long: self.long
        )
    }
    
}

public extension TransactionModel {
    
    static let mocks: [TransactionModel] = [
        .mockClassicTransaction,
        .mockClassicTransaction2,
        .mockClassicTransaction3,
        .mockClassicTransaction4,
        .mockTransactionFromSubscription,
        .mockApplePayTransaction,
        .mockTransferTransaction
    ]
    
}

public extension TransactionModel {
    
    static let mockClassicTransaction: TransactionModel = .init(
        id: 1,
        name: "Mock Classic Transaction",
        amount: 20,
        date: Date.now,
        category: CategoryModel.mock,
        subcategory: SubcategoryModel.mock,
        lat: 49.253518498825116,
        long: 6.05911732080831
    )
    
    static let mockTransferTransaction: TransactionModel = .init(
        id: 2,
        name: "",
        amount: 300,
        date: Date.now,
        senderAccount: AccountModel.mockClassicAccount,
        receiverAccount: AccountModel.mockSavingsAccount
    )
    
    static let mockApplePayTransaction: TransactionModel = .init(
        id: 3,
        name: "Culture Pain",
        amount: 6,
        date: Date.now,
        category: CategoryModel.mock,
        subcategory: SubcategoryModel.mock,
        isFromApplePay: true,
        lat: 49.253518498825116,
        long: 6.05911732080831
    )
    
    static let mockTransactionFromSubscription: TransactionModel = .init(
        id: 4,
        name: "Spotify",
        amount: 21,
        date: Date.now,
        isFromSubscription: true
    )
    
    static let mockClassicTransaction2: TransactionModel = .init(
        id: 5,
        name: "Action",
        amount: 27.12,
        date: Date.now,
        category: CategoryModel.mock,
        subcategory: SubcategoryModel.mock,
    )
    
    static let mockClassicTransaction3: TransactionModel = .init(
        id: 6,
        name: "Cedaf SARL",
        amount: 1.2,
        date: Date.now
    )
    
    static let mockClassicTransaction4: TransactionModel = .init(
        id: 7,
        name: "Robot trading",
        amount: 25,
        date: Date.now
    )
    
}
