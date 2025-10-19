//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 15/10/2025.
//

import SwiftUI
import DesignSystem
import Models
import Navigation
import CategoryModule
import Dependencies

struct HomeTopExpensesSectionView: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore
    
    // MARK: Computed variables
    var categories: [CategoryModel] {
        let transactions = transactionStore.getExpenses(in: Date())
        let groupedByCategory = Dictionary(grouping: transactions, by: { $0.category })
        let categoryTotals: [(category: CategoryModel?, total: Double)] = groupedByCategory.map { (category, transactions) in
            let total = transactions.reduce(0) { $0 + $1.amount }
            return (category, total)
        }
        let sortedCategories = categoryTotals
            .sorted { $0.total > $1.total }
            .compactMap(\.category)
        
        return Array(sortedCategories.prefix(3))
    }
    
    // MARK: - Views
    var body: some View {
        if categories.isNotEmpty {
            VStack(spacing: Spacing.medium) {
                HomeSectionHeaderView(
                    title: "home_top_expenses_of_month".localized,
                    destination: .category(.list)
                )
                
                ForEach(categories) { category in
                    NavigationButtonView(
                        route: .push,
                        destination: .subcategory(.list(category: category, selectedDate: Date()))
                    ) {
                        CategoryRowView(category: category, selectedDate: Date())
                    }
                }
            }
        } else {
            
        }
    }
    
}

// MARK: - Preview
#Preview {
    HomeTopExpensesSectionView()
}
