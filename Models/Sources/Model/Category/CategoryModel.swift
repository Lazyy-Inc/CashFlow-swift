//
//  CategoryModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 26/11/2024.
//

import Foundation
import SwiftUI

public struct CategoryModel: Identifiable, Equatable, Hashable {
    public var id: Int
    public var name: String
    public var icon: String
    public var color: Color
    public var subcategories: [SubcategoryModel]?
    
    public init(id: Int, name: String, icon: String, color: Color, subcategories: [SubcategoryModel]? = nil) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.subcategories = subcategories
    }
}

public extension CategoryModel {
    
    var isIncome: Bool {
        return self.name == "word_income".localized
    }
    
    var isToCategorized: Bool {
        return self.name == "category00_name".localized
    }
    
}

//public extension CategoryModel {
//    
////    var transactionsFiltered: [TransactionModel] {
////        return self.transactions
////            .filter { Calendar.current.isDate($0.date, equalTo: FilterManager.shared.date, toGranularity: .month) }
////    }
//    
//    var categorySlices: [PieSliceData] {
//        var array: [PieSliceData] = []
//        let filterManager = FilterManager.shared
//        
//        for subcategory in self.subcategories ?? [] {
//            let transactionsFiltered = subcategory.transactions
//                .filter { Calendar.current.isDate($0.date, equalTo: filterManager.date, toGranularity: .month) }
//            
//            let amount = transactionsFiltered
//                .map { $0.amount }
//                .reduce(0, +)
//            
//            if amount != 0 {
//                array.append(
//                    .init(
//                        categoryID: self.id,
//                        subcategoryID: subcategory.id,
//                        icon: subcategory.icon,
//                        value: subcategory.transactionsFiltered
//                            .map { $0.amount }
//                            .reduce(0, +),
//                        color: subcategory.color
//                    )
//                )
//            }
//        }
//        
//        return array
//    }
//        
//}
