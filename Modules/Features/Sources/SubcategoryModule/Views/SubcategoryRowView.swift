//
//  SubcategoryRowView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 19/06/2023.
//

import SwiftUI
import DesignSystem
import Core
import Dependencies
import Models
import Stores
import Mocks

struct SubcategoryRowView: View {
    
    // MARK: Dependencies
    var subcategory: SubcategoryModel
    var selectedDate: Date
    
    // MARK: Environments
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    
    // Computed var
    var stringAmount: String {
        return transactionStore.getExpenses(for: subcategory, in: selectedDate)
            .compactMap(\.amount)
            .reduce(0, +)
            .toCurrency()
    }
    
    // MARK: -
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(subcategory.color)
                .frame(width: 36, height: 36)
                .overlay {
                    IconSVG(icon: subcategory.icon, value: .medium)
                        .foregroundStyle(Color.white)
                }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(subcategory.name)
                    .font(.Body.mediumBold)
                    .foregroundStyle(Color.Text.primary)
                    .lineLimit(1)
                
                Text(stringAmount)
                    .font(.Body.small)
                    .foregroundStyle(Color.Background.bg600)
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
