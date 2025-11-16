//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 14/11/2025.
//

import Foundation

public protocol FinancialItemProtocol: Searchable {
    var name: String { get set }
    var amount: Double { get set }
    var type: FinancialItemType { get }
    var date: Date { get }
    
    var category: CategoryModel? { get }
    var subcategory: SubcategoryModel? { get }
    
    var senderAccount: AccountModel? { get }
    var receiverAccount: AccountModel? { get }
}
