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
import Mocks
import Stores
import Dependencies

public struct CategoryRowView: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var selectedDate: Date
    
    @Dependency(\.transactionStore) private var transactionStore
    
    // MARK: Init
    public init(category: CategoryModel, selectedDate: Date) {
        self.category = category
        self.selectedDate = selectedDate
    }
            
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.small) {
            CircleColoredWithIconView(
                circleColor: category.color,
                icon: category.icon,
                iconColor: Color.white
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(category.name)
                    .font(.Body.medium)
                    .foregroundStyle(Color.Text.primary)
                    .lineLimit(1)
                
                Text(amount.toCurrency())
                    .font(.Body.small)
                    .animation(.smooth, value: amount)
                    .contentTransition(.numericText())
                    .foregroundStyle(Color.Background.bg600)
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
        transactionStore.getTransactions(for: category, in: selectedDate)
            .map(\.amount)
            .reduce(0, +)
    }
    
}

// MARK: - Preview
#Preview {
    CategoryRowView(category: .mock, selectedDate: .now)
}
