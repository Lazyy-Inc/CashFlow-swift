//
//  CategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI
import DesignSystem
import Core
import Models
import DataSources

public struct CategoryRowView: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
        
    // MARK: Constants
    private let transactionDataSource: TransactionDataSource
    
    // MARK: Init
    public init(
        category: CategoryModel,
        selectedDate: Date,
        transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared
    ) {
        self.category = category
        self.selectedDate = selectedDate
        self.transactionDataSource = transactionDataSource
    }
            
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.small) {
            CircleColoredWithIconView(
                circleColor: category.color,
                icon: category.icon
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(category.name)
                    .font(.Body.medium, color: .Text.primary)
                    .lineLimit(1)
                
                Text(amount.toCurrency())
                    .font(.Body.small, color: .Text.secondary)
                    .animation(.smooth, value: amount)
                    .contentTransition(.numericText())
                    .lineLimit(1)
            }
            .fullWidth(.leading)
            
            IconSVG(icon: "iconArrowRight", value: .large)
                .foregroundStyle(Color.Background.bg600)
        }
        .padding(Padding.medium)
        .roundedBackground(.classic)
    }
}

// MARK: - Computed variables
extension CategoryRowView {
    
    var amount: Double {
        return transactionDataSource.transactions(for: .category(category, month: selectedDate))
            .map(\.amount)
            .reduce(0, +)
    }
    
}

// MARK: - Preview
#Preview {
    CategoryRowView(category: .mock, selectedDate: .now)
}
