//
//  BudgetModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation
import SwiftUI

public struct BudgetModel: Codable, Identifiable, Equatable, Hashable, Sendable {
    public var id: Int?
    var _amount: Double?
    public var categoryID: Int?
    public var subcategoryID: Int?

    // Initialiseur
    public init(id: Int? = nil, amount: Double? = nil, categoryID: Int? = nil, subcategoryID: Int? = nil) {
        self.id = id
        self._amount = amount
        self.categoryID = categoryID
        self.subcategoryID = subcategoryID
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, categoryID, subcategoryID
        case _amount = "amount"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decodeIfPresent(Int.self, forKey: .id)
        _amount = try container.decodeIfPresent(Double.self, forKey: ._amount)
        categoryID = try container.decodeIfPresent(Int.self, forKey: .categoryID)
        subcategoryID = try container.decodeIfPresent(Int.self, forKey: .subcategoryID)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(id, forKey: .id)
        try container.encodeIfPresent(_amount, forKey: ._amount)
        try container.encodeIfPresent(categoryID, forKey: .categoryID)
        try container.encodeIfPresent(subcategoryID, forKey: .subcategoryID)
    }
}

public extension BudgetModel {
    
    var amount: Double {
        return self._amount ?? 0
    }
    
}

public extension BudgetModel {
    
    static let mock: BudgetModel = .init(
        id: 1,
        amount: 300,
        categoryID: 2,
        subcategoryID: 1
    )
    
}
