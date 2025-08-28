//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation
import Models
import NetworkModule

public extension SubscriptionDTO {
 
    func toModel() throws -> SubscriptionModel {
        guard let id,
              let name,
              let amount,
              let typeNum,
              let frequencyNum,
              let frequencyDate,
              let categoryID else { throw NetworkError.unknown }
        
        guard let type = TransactionType(rawValue: typeNum),
              let frequency = SubscriptionFrequency(rawValue: frequencyNum),
              let date = frequencyDate.toDate() else {
            throw NetworkError.unknown
        }
        
        let transactionModels = try? transactions?.map { try $0.toModel() }
        
        return SubscriptionModel(
            id: id,
            name: name,
            amount: amount,
            type: type,
            frequency: frequency,
            frequencyDate: date,
            categoryID: categoryID,
            subcategoryID: subcategoryID,
            firstSubscriptionDate: firstSubscriptionDate?.toDate(),
            transactions: transactionModels
        )
    }
    
}
