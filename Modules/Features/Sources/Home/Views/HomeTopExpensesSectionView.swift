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
import DataSources

struct HomeTopExpensesSectionView: View {
    
    // MARK: Dependencies
    let transactionDataSource: TransactionDataSource
    
    // MARK: Init
    init(transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared) {
        self.transactionDataSource = transactionDataSource
    }
    
    // MARK: - View
    var body: some View {
        VStack(spacing: .medium) {
            HomeSectionHeaderView(
                title: "home_top_expenses_of_month".localized,
                destination: .category(.list)
            )
            
            ForEach(categories) { category in
                NavigationButtonView(
                    route: .push,
                    destination: .subcategory(.list(category: category, selectedDate: .now))
                ) {
                    CategoryRowView(category: category, selectedDate: .now)
                }
            }
        }
        .isDisplayed(categories.isNotEmpty)
    }
    
}

// MARK: - UI variables
extension HomeTopExpensesSectionView {
    
    var categories: [CategoryModel] {
        let transactions = transactionDataSource.transactions(for: .type(.expense, month: .now))
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
    
}

// MARK: - Preview
#Preview {
    HomeTopExpensesSectionView()
}
