//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 30/09/2025.
//

import Foundation
import Core
import Models
import Stores
import DataSources

public extension CategoryStore {
    
    private func computeSubcategoryData(for month: Date, in category: CategoryModel) -> [Int?: SubcategoryTransactionData] {
        let transactionDataSource = DefaultTransactionDataSource.shared
        let allMonthTransactions = transactionDataSource.transactions(for: .category(category, month: month))
        let transactionsBySubcategory = Dictionary(grouping: allMonthTransactions) { $0.subcategory }
        
        return Dictionary(uniqueKeysWithValues: (category.subcategories ?? [])
            .compactMap { subcategory in
                let subcategoryTransactions = transactionsBySubcategory[subcategory, default: []]
                if subcategoryTransactions.isEmpty { return nil }
                return (
                    subcategory.id,
                    SubcategoryTransactionData(
                        subcategory: subcategory,
                        transactions: subcategoryTransactions
                    )
                )
            })
    }
    
    func subcategoriesSlices(for category: CategoryModel, in month: Date) -> [PieSliceData] {
        let slices = computeSubcategoryData(for: month, in: category)
            .values
            .map { data in
                PieSliceData(
                    title: data.subcategory.name,
                    icon: data.subcategory.icon,
                    value: data.totalAmount,
                    color: data.subcategory.color
                )
            }
        return slices
    }
    
}
