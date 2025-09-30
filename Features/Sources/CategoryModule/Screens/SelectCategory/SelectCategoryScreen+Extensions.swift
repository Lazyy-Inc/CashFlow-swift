//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 30/09/2025.
//

import Foundation
import Models

// MARK: - Stored variables
extension SelectCategoryScreen {
  
  @Observable
  final class ViewModel {
    
    var searchText: String = ""
    
  }
  
}

// MARK: - Computed variables
extension SelectCategoryScreen.ViewModel {
  
  var categoriesFiltered: [CategoryModel] {
      return categoryStore.categories
          .searchFor(searchText)
  }
  
}
