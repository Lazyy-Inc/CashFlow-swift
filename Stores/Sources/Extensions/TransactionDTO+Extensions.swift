//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models
import NetworkModule
import Dependencies

public extension TransactionDTO {
    
    func toModel() throws -> TransactionModel {
        guard let id,
              let amount,
              let dateISO
        else { throw NetworkError.unknown }
      
        @Dependency(\.categoryStore) var categoryStore
                
        let date = dateISO.toDate()
      
        let category = categoryStore.findCategoryById(categoryID)
        let subcategory = categoryStore.findSubcategoryById(subcategoryID)
      
        let repartitionType = RepartitionType(rawValue: repartitionType ?? "")
        
        let senderAccount = AccountStore.shared.findByID(senderAccountID)
        let receiverAccount = AccountStore.shared.findByID(receiverAccountID)
        
        return .init(
            id: id,
            name: name ?? "",
            amount: amount,
            date: date ?? .now,
            creationDate: creationDate?.toDate(),
            category: category,
            subcategory: subcategory,
            repartitionType: repartitionType,
            note: note,
            isFromSubscription: isFromSubscription ?? false,
            isFromApplePay: isFromApplePay ?? false,
            nameFromApplePay: nameFromApplePay,
            autoCat: autoCat,
            senderAccount: senderAccount,
            receiverAccount: receiverAccount,
            address: address,
            lat: lat,
            long: long
        )
    }
}
