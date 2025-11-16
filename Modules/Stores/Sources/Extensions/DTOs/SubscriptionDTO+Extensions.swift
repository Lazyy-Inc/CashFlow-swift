//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models
import NetworkModule
import Dependencies

public extension SubscriptionDTO {
 
    func toModel() throws -> SubscriptionModel {
        guard let id,
              let name,
              let amount,
              let typeNum,
              let frequencyNum,
              let frequencyDate,
              let categoryID else { throw NetworkError.unknown }
        
        guard let type = FinancialItemType(rawValue: typeNum),
              let frequency = SubscriptionFrequency(rawValue: frequencyNum),
              let date = frequencyDate.toDate() else {
            throw NetworkError.unknown
        }
        
        let transactionModels = try? transactions?.map { try $0.toModel() }
        
        @Dependency(\.categoryStore) var categoryStore
        
        let category = categoryStore.findCategoryById(categoryID)
        let subcategory = categoryStore.findSubcategoryById(subcategoryID)
        
        return SubscriptionModel(
            id: id,
            name: name,
            amount: amount,
            type: type,
            frequency: frequency,
            frequencyDate: date,
            category: category,
            subcategory: subcategory,
            firstSubscriptionDate: firstSubscriptionDate?.toDate(),
            lastSubscriptionDate: lastSubscriptionDate?.toDate(),
            transactions: transactionModels
        )
    }
    
}
