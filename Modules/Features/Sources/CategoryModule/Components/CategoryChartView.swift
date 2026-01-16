//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 16/01/2026.
//

import SwiftUI
import Models

struct CategoryChartView: View {
    
    // MARK: Dependencies
    let items: [CategoryModel: [TransactionModel]]
    
    // MARK: - View
    var body: some View {
        VStack(spacing: .large) {
            VStack(spacing: .medium) {
                ForEach(chartItems, id: \.self) { item in
                    CategoryChartItemView(item: item, totalAmount: totalAmount)
                }
            }
        }
        .padding(.standard)
        .roundedBackground(.classic)
    }
}

// MARK: - Computed variables
extension CategoryChartView {
    
    private var totalAmount: Double {
        items
            .flatMap { $0.value }
            .map(\.amount)
            .reduce(0, +)
    }
    
    private var chartItems: [CategoryChartUIModel] {
        items
            .map { CategoryChartUIModel(category: $0.key, transactions: $0.value) }
            .sorted(by: { $0.amount > $1.amount })
    }
    
}

// MARK: - Preview
#Preview {
    CategoryChartView(
        items: [
            .mock: [.mockClassicTransaction, .mockClassicTransaction2]
        ]
    )
}
