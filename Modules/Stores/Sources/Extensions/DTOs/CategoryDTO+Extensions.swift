//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models
import NetworkModule
import SwiftUI

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
