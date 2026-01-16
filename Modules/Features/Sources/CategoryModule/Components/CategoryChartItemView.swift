//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 16/01/2026.
//

import SwiftUI
import Models
import DesignSystem
import Utilities

struct CategoryChartItemView: View {
    
    // MARK: Dependencies
    let item: CategoryChartUIModel
    let totalAmount: Double
    
    // MARK: States
    @State private var barWidth: CGFloat = 0
    
    // MARK: - View
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: .tiny) {
                Text(item.amount.toCurrency())
                    .font(.Body.mediumBold, color: item.color)
                
                Text("/ " + item.categoryName.localized)
                    .font(.Label.large, color: .Text.secondary)
                    .fullWidth(.leading)
            }
                        
            HStack(spacing: .tiny) {
                UnevenRoundedRectangle(
                    topLeadingRadius: .tiny,
                    bottomLeadingRadius: .tiny,
                    bottomTrailingRadius: .medium,
                    topTrailingRadius: .medium,
                    style: .continuous
                )
                .fill(barWidth == 0 ? .clear : item.color)
                .frame(width: barWidth != 0 ? barWidth * percentage : nil, height: 16)
                .getSize(onlyOnLoad: true) { size in
                    barWidth = 1
                    withAnimation(.smooth(duration: 0.8)) { barWidth = size.width }
                }
                
                Text((percentage * 100).toString(maxDigits: 0) + " %")
                    .font(.Label.large, color: item.color)
            }
        }
    }
}

// MARK: - Computed variables
extension CategoryChartItemView {
    
    private var percentage: Double {
        min(item.amount / totalAmount, 1)
    }
    
}

// MARK: - Preview
#Preview {
    CategoryChartItemView(item: .mock, totalAmount: 100)
        .padding()
}
