//
//  ReleaseNoteModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import Foundation

public struct ReleaseNoteModel: Equatable, Hashable {
    public let version: String
    public let date: String

    public let newFeatures: [String]?
    public let newFeaturesPro: [String]?
    public let bugfixes: [String]?
    
    public init(
        version: String,
        date: String,
        newFeatures: [String]?,
        newFeaturesPro: [String]?,
        bugfixes: [String]?
    ) {
        self.version = version
        self.date = date
        self.newFeatures = newFeatures
        self.newFeaturesPro = newFeaturesPro
        self.bugfixes = bugfixes
    }
}

public extension ReleaseNoteModel {
 
    static let version2_0_4: ReleaseNoteModel = .init(
        version: "2.0.4",
        date: Date.create(day: 1, month: 5, year: 2025)?.formatted(date: .numeric, time: .omitted) ?? "",
        newFeatures: [
            "feature_204_contribution".localized,
            "feature_204_categories".localized,
            "feature_204_select_account".localized,
            "feature_204_futur_amount".localized,
            "feature_204_applepay".localized,
            "feature_204_transfer_subscription".localized
        ],
        newFeaturesPro: [
            "feature_pro_204_applepay".localized,
            "feature_pro_204_account".localized
        ],
        bugfixes: [
            "bugfix_204_transactions".localized,
            "bugfix_204_preferences".localized
        ]
    )
    
}
