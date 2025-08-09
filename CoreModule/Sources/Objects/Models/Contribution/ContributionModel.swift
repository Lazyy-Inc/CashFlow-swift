//
//  ContributionModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 12/11/2024.
//

import Foundation

public enum ContributionType: Int, CaseIterable {
    case addition = 0
    case withdrawal = 1
    
    public var name: String {
        switch self {
        case .addition:     return "contribution_add".localized
        case .withdrawal:   return "contribution_withdraw".localized
        }
    }
}

public struct ContributionModel: Codable, Identifiable, Equatable, Hashable {
    public var id: Int?
    public var name: String?
    public var amount: Double?
    public var typeNum: Int? // ContributionType
    public var dateString: String?

    // Initialiseur
    public init(id: Int? = nil, name: String? = nil, amount: Double? = nil, typeNum: Int? = nil, dateString: String? = nil) {
        self.id = id
        self.name = name
        self.amount = amount
        self.typeNum = typeNum
        self.dateString = dateString
    }

    // Conformance au protocole Codable
    private enum CodingKeys: String, CodingKey {
        case id, name, amount
        case dateString = "date"
        case typeNum = "type"
    }
}

public extension ContributionModel {
    
    var type: ContributionType {
        return ContributionType(rawValue: typeNum ?? 0) ?? .addition
    }
    
    var symbol: String {
        switch type {
        case .addition:     return "+"
        case .withdrawal:   return "-"
        }
    }
    
    var date: Date {
        return self.dateString?.toDate() ?? .now
    }
    
}
