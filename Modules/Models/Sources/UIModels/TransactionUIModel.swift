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
}

// MARK: - Protocol
extension TransactionUIModel: FinancialItemProtocol {
    
    public var searchableText: String { name }
    
    public var type: FinancialItemType { // TODO: Remove if Remi agree to change in backend
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
