//
//  SubcategorySelectableRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import DesignSystem
import Core
import Models

public struct SubcategorySelectableRowView: View {
    
    // MARK: Dependencies
    var subcategory: SubcategoryModel
    var isSelected: Bool
    var action: () -> Void
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    
    // MARK: Init
    public init(
        subcategory: SubcategoryModel,
        isSelected: Bool,
        action: @escaping () -> Void
    ) {
        self.subcategory = subcategory
        self.isSelected = isSelected
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button(action: action) {
            HStack(spacing: .small) {
                CircleColoredWithIconView(
                    circleColor: subcategory.color,
                    icon: subcategory.icon
                )
                
                Text(subcategory.name)
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
    SubcategorySelectableRowView(subcategory: .mock, isSelected: true, action: { })
}
