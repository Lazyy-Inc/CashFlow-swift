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
            HStack {
                Circle()
                    .foregroundStyle(category.color)
                    .frame(width: 35, height: 35)
                    .overlay {
                        IconSVG(icon: category.icon, value: .standard)
                            .foregroundStyle(Color.white)
                    }
                
                Text(category.name)
                    .font(.Body.medium)
                    .lineLimit(1)
                
                Spacer()
            }
            .padding(Padding.standard)
            .roundedBackground(
                .custom(
                    color: .Background.bg200,
                    radius: .standard,
                    strokeColor: nil
                )
            )
            .overlay(.topTrailing, condition: isSelected) {
                ZStack {
                    Circle()
                        .frame(width: 25, height: 25)
                        .foregroundStyle(theme.color)
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .heavy, design: .rounded))
                        .foregroundStyle(.white)
                }
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
