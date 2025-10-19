//
//  CategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 18/06/2023.
//

import SwiftUI
import TheoKit
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
                    .fontWithLineHeight(.Body.medium)
                    .foregroundStyle(Color.label)
                    .lineLimit(1)
                
                Text(amount.toCurrency())
                    .fontWithLineHeight(.Body.small)
                    .animation(.smooth, value: amount)
                    .contentTransition(.numericText())
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    .lineLimit(1)
            }
            .fullWidth(.leading)
            
            IconSVG(icon: "iconArrowRight", value: .large)
                .foregroundStyle(Color.Background.bg600)
        }
        .padding(Padding.medium)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
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
