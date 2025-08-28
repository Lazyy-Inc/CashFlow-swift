//
//  ContributionResponseWithAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation
import Models

public struct ContributionResponseWithAmount: Codable {
    public var newAmount: Double?
    public var contribution: ContributionModel?
    
    public init(newAmount: Double? = nil, contribution: ContributionModel? = nil) {
        self.newAmount = newAmount
        self.contribution = contribution
    }
}
