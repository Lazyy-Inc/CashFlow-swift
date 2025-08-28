//
//  CategoryStore.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import Foundation
import Models
import NetworkModule

public final class CategoryStore: ObservableObject {
    public static let shared = CategoryStore()
    
    @Published public var categories: [CategoryModel] = []
    @Published public var subcategories: [SubcategoryModel] = []
}

public extension CategoryStore {
  
  @MainActor
  func fetchCategories() async {
      do {
          let categories = try await NetworkService.sendRequest(
              apiBuilder: CategoryAPIRequester.fetchCategories,
              responseModel: [CategoryDTO].self
          ).map { try $0.toModel() }
          self.categories = categories
          for (index, category) in self.categories.enumerated() {
              self.categories[index].subcategories = category.subcategories?.filter { $0.isVisible }
          }
          self.subcategories = categories.flatMap { $0.subcategories ?? [] }
      } catch { NetworkService.handleError(error: error) }
  }
  
}

// MARK: - Utils
public extension CategoryStore {
  
  var toCategorized: CategoryModel? {
    return self.categories.first { $0.isToCategorized }
  }
  
  func findCategoryByName(_ name: String) -> CategoryModel? {
    return self.categories.first(where: { $0.name == name })
  }
  
  func findCategoryById(_ id: Int?) -> CategoryModel? {
    return self.categories.first(where: { $0.id == id })
  }
  
  func findSubcategoryById(_ id: Int?) -> SubcategoryModel? {
    return self.subcategories.first(where: { $0.id == id })
  }
  
  func reset() {
    self.categories = []
    self.subcategories = []
  }
  
}
