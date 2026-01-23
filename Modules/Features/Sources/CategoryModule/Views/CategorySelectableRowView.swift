//
//  CategorySelectableRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import DesignSystem
import Core
import Models

struct CategorySelectableRowView: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    var isSelected: Bool
    var action: () -> Void
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    
    // MARK: -
    var body: some View {
        Button(action: action) {
            HStack(spacing: .small) {
                CircleColoredWithIconView(
                    circleColor: category.color,
                    icon: category.icon
                )
                
                Text(category.name)
                    .font(.Body.medium)
                    .lineLimit(1)
                    .fullWidth(.leading)
            }
            .padding(.medium)
            .roundedBackground(.row)
            .overlay(.trailing, condition: isSelected) {
                IconView(asset: .iconCheck, size: .extraSmall, color: .Base.white)
                    .padding(.small)
                    .background(theme.color, in: .circle)
                    .padding(8)
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    CategorySelectableRowView(
        category: .mock,
        isSelected: true
    ) { }
}
