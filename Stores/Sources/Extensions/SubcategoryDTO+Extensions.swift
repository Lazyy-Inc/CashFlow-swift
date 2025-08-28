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
