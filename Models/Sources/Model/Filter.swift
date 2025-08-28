//
//  Filter.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/07/2023.
//

import Foundation
import SwiftUI

public class Filter: Identifiable, ObservableObject { // TODO: To be deleted
    @MainActor public static let shared = Filter()
    public var id: UUID = UUID()
    
    @Published public var date: Date = Date()
    
    @Published public var showMenu: Bool = false
    @Published public var fromBudget: Bool = false
    @Published public var fromAnalytics: Bool = false
    
    @Published public var byDay: Bool = false
    @Published public var automation: Bool = false
    @Published public var total: Bool = false
}

@MainActor public let sharedFilter = Filter.shared
