//
//  ContributionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation

public extension ContributionModel {
    
    static let mockContribution: ContributionModel = .init(
        amount: 100,
        dateString: Date().toISO()
    )
    
}
