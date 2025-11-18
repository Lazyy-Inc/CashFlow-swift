//
//  PredictedCategoryRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI
import Core
import DesignSystem
import Models

struct PredictedCategoryRowView: View {
    
    // Builder
    var category: CategoryModel
    var subcategory: SubcategoryModel?
    var action: (() -> Void)?
    
    var icon: String {
        if let subcategory {
            return subcategory.icon
        } else { return category.icon }
    }
    
    var text: String {
        if let subcategory {
            return subcategory.name
        } else { return category.name }
    }
   
    // MARK: -
    var body: some View {
        Button {
            if let action { action() }
        } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 6) {
                    IconSVG(icon: icon, value: .small)
                        .foregroundStyle(Color.white)
                        .padding(6)
                        .background {
                            Circle()
                                .fill(Color.Background.bg300)
                        }
                    Text("transaction_recommended_category".localized)
                        .font(.Body.medium, color: .white)
                    
                    Spacer()
                }
                
                Text(text)
                    .font(.semiBoldText16())
                    .foregroundStyle(Color.white)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(category.color)
            }
        }
    } // bdoy
} // struct

// MARK: - Preview
#Preview {
    PredictedCategoryRowView(
        category: .mock,
        subcategory: .mock
    )
}
