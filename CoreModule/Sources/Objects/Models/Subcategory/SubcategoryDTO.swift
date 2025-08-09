//
//  SubcategoryDTO.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/05/2025.
//

import Foundation
import SwiftUICore
import NetworkKit

public struct SubcategoryDTO: Codable, Equatable, Hashable {
    public var id: Int?
    public var name: String?
    public var icon: String?
    public var color: String?
    public var isVisible: Bool?
}

public extension SubcategoryDTO {

    func toModel() throws -> SubcategoryModel {
        guard let id,
              let name,
              let icon,
              let color,
              let isVisible
        else { throw NetworkError.parsingError }
        
        return SubcategoryModel(
            id: id,
            name: name.localized,
            icon: icon,
            color: Color(hex: color),
            isVisible: isVisible
        )
    }
    
}
    
