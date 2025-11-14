//
//  SubcategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/05/2025.
//

import Foundation
import SwiftUI

public struct SubcategoryDTO: Codable, Equatable, Hashable, Sendable {
    public var id: Int?
    public var name: String?
    public var icon: String?
    public var color: String?
    public var isVisible: Bool?
}
