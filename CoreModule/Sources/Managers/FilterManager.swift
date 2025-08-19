//
//  FilterManager.swift
//  CashFlow
//
//  Created by KaayZenn on 16/03/2024.
//

import Foundation

public class FilterManager: ObservableObject {
    public static let shared = FilterManager()
    
    @Published public var byMonth: Bool = false
    @Published public var date: Date = Date()
    
    @Published public var onlyExpenses: Bool = false
    @Published public var onlyIncomes: Bool = false
    
    @Published public var sortBy: FilterSort = .date
}

public enum FilterSort {
    case date
    case ascendingOrder
    case descendingOrder
    case alphabetic
}
