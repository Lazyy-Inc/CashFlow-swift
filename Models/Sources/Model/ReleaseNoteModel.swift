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
