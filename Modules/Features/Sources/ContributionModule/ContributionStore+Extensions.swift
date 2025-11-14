//
//  ContributionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import Core
import Models
import Stores

extension ContributionStore {
    
    public func getContributionsAmountByMonth(for year: Int) -> [Double] {
        var contributionsByMonth = Array(repeating: 0.0, count: 12)
        
        let contributionsFiltered: [ContributionModel] = contributions
            .filter { $0.date.year == year }
        
        let grouped = Dictionary(grouping: contributionsFiltered) { Calendar.current.component(.month, from: $0.date) }
        
        for (month, contributions) in grouped {
            let additions = contributions.filter { $0.type == .addition }.compactMap(\.amount).reduce(0, +)
            let withdrawals = contributions.filter { $0.type == .withdrawal }.compactMap(\.amount).reduce(0, +)
            let totalAmount = additions - withdrawals
            contributionsByMonth[month - 1] = totalAmount
        }
        
        return contributionsByMonth
    }
    
}
