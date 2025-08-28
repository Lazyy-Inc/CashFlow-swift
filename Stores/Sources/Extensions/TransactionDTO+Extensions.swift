//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 27/08/2025.
//

//import Foundation
//
//public extension TransactionDTO {
//    
//    func toModel() throws -> TransactionModel {
//        guard let id,
//              let amount,
//              let dateISO
//        else { throw NetworkError.unknown }
//                
//        let date = dateISO.toDate()
//        let category = CategoryStore.shared.findCategoryById(categoryID)
//        
//        let subcategory = CategoryStore.shared.findSubcategoryById(subcategoryID)
//        
//        let senderAccount = AccountStore.shared.findByID(senderAccountID)
//        let receiverAccount = AccountStore.shared.findByID(receiverAccountID)
//        
//        return .init(
//            id: id,
//            name: name ?? "",
//            amount: amount,
//            date: date ?? .now,
//            creationDate: creationDate?.toDate(),
//            category: category,
//            subcategory: subcategory,
//            note: note,
//            isFromSubscription: isFromSubscription ?? false,
//            isFromApplePay: isFromApplePay ?? false,
//            nameFromApplePay: nameFromApplePay,
//            autoCat: autoCat,
//            senderAccount: senderAccount,
//            receiverAccount: receiverAccount,
//            address: address,
//            lat: lat,
//            long: long
//        )
//    }
//}
