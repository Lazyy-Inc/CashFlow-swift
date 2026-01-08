//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 08/01/2026.
//

import Foundation

public struct PaywallUIModel: UIModel {
    public let id: UUID = UUID()
    public let icon: ImageType
    public let title: String
    public let description: String
    
    public init(
        icon: ImageType,
        title: String,
        description: String
    ) {
        self.icon = icon
        self.title = title
        self.description = description
    }
}

// MARK: - Mocks
public extension PaywallUIModel {
    
    @MainActor
    static let mock: PaywallUIModel = .init(
        icon: .iconPieChart,
        title: "Budgets",
        description: "Création d’un budget avec la règle 50-30-20, d’autres règles sont sélectionnable ou création d’une règle personnalisé"
    )
    
}
