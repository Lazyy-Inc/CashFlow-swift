//
//  CategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import Foundation
import SwiftUICore
import NetworkKit

public struct CategoryDTO: Codable, Equatable, Hashable {
    public var id: Int?
    public var name: String?
    public var icon: String?
    public var color: String?
    public var subcategories: [SubcategoryDTO]?
}

public extension CategoryDTO {
    
    func toModel() throws -> CategoryModel {
        guard let id,
              let name,
              let icon,
              let color
        else { throw NetworkError.parsingError }
        
        return .init(
            id: id,
            name: name.localized,
            icon: icon,
            color: Color(hex: color),
            subcategories: try subcategories?.map { try $0.toModel() } ?? []
        )
    }
}
