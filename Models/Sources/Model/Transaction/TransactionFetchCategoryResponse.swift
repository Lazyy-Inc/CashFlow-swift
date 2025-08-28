//
//  TransactionFetchCategoryResponse.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation

public struct TransactionFetchCategoryResponse: Codable, Sendable {
    public var cat: Int?
    public var sub: Int?
    
    public init(cat: Int? = nil, sub: Int? = nil) {
        self.cat = cat
        self.sub = sub
    }
}
