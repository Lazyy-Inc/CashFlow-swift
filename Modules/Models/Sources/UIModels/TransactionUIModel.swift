//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 15/01/2026.
//

import Foundation

public struct TransactionUIModel: UIModel {
    public let id: Int
    
    public var name: String
    public var amount: Double
    public var date: Date
    
    public var category: CategoryModel?
    public var subcategory: SubcategoryModel?
    
    public var repartitionType: RepartitionType?

    public var isFromSubscription: Bool
    public var isFromApplePay: Bool
    public var nameFromApplePay: String?

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
        category: CategoryModel? = nil,
        subcategory: SubcategoryModel? = nil,
        repartitionType: RepartitionType? = nil,
        isFromSubscription: Bool,
        isFromApplePay: Bool,
        nameFromApplePay: String? = nil,
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
        self.category = category
        self.subcategory = subcategory
        self.repartitionType = repartitionType
        self.isFromSubscription = isFromSubscription
        self.isFromApplePay = isFromApplePay
        self.nameFromApplePay = nameFromApplePay
        self.senderAccount = senderAccount
        self.receiverAccount = receiverAccount
        self.address = address
        self.lat = lat
        self.long = long
    }
}

// MARK: - Protocol
extension TransactionUIModel: FinancialItemProtocol {
    
    public var searchableText: String { name }
    
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
