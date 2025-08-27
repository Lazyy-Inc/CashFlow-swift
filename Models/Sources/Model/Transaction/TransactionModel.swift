//
//  TransactionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUICore
import TheoKit

public struct TransactionModel: Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var amount: Double
    public var date: Date
    public var creationDate: Date?
    public var category: CategoryModel?
    public var subcategory: SubcategoryModel?
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
        note: String? = nil,
        isFromSubscription: Bool,
        isFromApplePay: Bool,
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

public extension TransactionModel {
    
    var type: TransactionType {
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
