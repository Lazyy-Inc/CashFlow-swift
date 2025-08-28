//
//  ContributionStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies
import Models

@Observable
public final class ContributionStore {
    public static let shared = ContributionStore()
    
    public var contributions: [ContributionModel] = []
}

public extension ContributionStore {
    
    func getContributions(in month: Date? = nil, type: ContributionType? = nil) -> [ContributionModel] {
        return contributions
            .filter { $0.type == type }
            .filter {
                if let month {
                    return Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
                } else { return true }
            }
    }
    
    func getAmountOfContributions(in month: Date? = nil) -> Double {
        let additions = getContributions(in: month, type: .addition).compactMap(\.amount).reduce(0, +)
        let withdrawals = getContributions(in: month, type: .withdrawal).compactMap(\.amount).reduce(0, +)
        return additions - withdrawals
    }
    
}

// MARK: - Dependencies
extension ContributionStore: DependencyKey {
    public static var liveValue: ContributionStore = .shared
}

public extension DependencyValues {
    var contributionStore: ContributionStore {
        get { self[ContributionStore.self] }
        set { self[ContributionStore.self] = newValue }
    }
}
