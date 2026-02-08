//
//  SubcategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI
import DesignSystem
import Core
import Models
import Providers

struct SubcategoryRowView: View {
    
    // MARK: Dependencies
    private let subcategory: SubcategoryModel
    private let selectedDate: Date
    
    // MARK: Constants
    private let transactionDataSource: TransactionProvider
    
    // MARK: Init
    init(
        subcategory: SubcategoryModel,
        selectedDate: Date,
        transactionDataSource: TransactionProvider = DefaultTransactionProvider.shared
    ) {
        self.subcategory = subcategory
        self.selectedDate = selectedDate
        self.transactionDataSource = transactionDataSource
    }
    
    // MARK: Computed variables
    private var stringAmount: String {
        return transactionDataSource.transactions(for: .subcategory(subcategory, month: selectedDate))
            .compactMap(\.amount)
            .reduce(0, +)
            .toCurrency()
    }
    
    // MARK: -
    var body: some View {
        HStack {
            CircleColoredWithIconView(
                circleColor: subcategory.color,
                icon: subcategory.icon
            )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(subcategory.name)
                    .font(.Body.medium, color: .Text.primary)
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.Body.small, color: .Text.secondary)
                    .lineLimit(1)
            }
            .fullWidth(.leading)
            
            IconSVG(icon: "iconArrowRight", value: .large)
                .foregroundStyle(Color.Text.primary)
        }
        .padding(Padding.medium)
        .roundedBackground(.classic)
    }
}

// MARK: - Preview
#Preview {
    SubcategoryRowView(subcategory: .mock, selectedDate: .now)
}
