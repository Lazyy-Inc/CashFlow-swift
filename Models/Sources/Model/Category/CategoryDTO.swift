//
//  CategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import Foundation
import SwiftUI

public struct CategoryDTO: Codable, Equatable, Hashable {
    public var id: Int?
    public var name: String?
    public var icon: String?
    public var color: String?
    public var subcategories: [SubcategoryDTO]?
}
