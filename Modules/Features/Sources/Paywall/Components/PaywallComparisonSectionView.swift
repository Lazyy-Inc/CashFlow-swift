//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import Models
import DesignSystem

struct PaywallComparisonSectionView: View {
    
    // MARK: Dependencies
    var comparisons: [PaywallComparisonUIModel]
    
    @State private var freeLabelSize: CGFloat = 0
    
    // MARK: - View
    var body: some View {
        VStack(spacing: .small) {
            headerView
            
            ForEach(comparisons) { comparison in
                Divider()
                comparisonRowView(comparison)
            }
        }
        .padding(.horizontal, .standard)
        .padding(.vertical, .medium)
        .roundedBackground(.classic)
    }
    
}

// MARK: - Subviews
extension PaywallComparisonSectionView {
    
    var headerView: some View {
        HStack(spacing: .small) { // TODO: TBL
            Text("paywall_comparison_title".localized)
                .font(.Body.mediumBold, color: .Base.black)
                .fullWidth(.leading)
            
            Text("paywall_comparison_free".localized)
                .font(.Body.mediumBold, color: .Secondary.secondary300)
                .getSize { freeLabelSize = $0.width }
                .frame(width: freeLabelSize != 0 ? freeLabelSize : nil)
            
            Text("paywall_comparison_max".localized)
                .font(.Body.mediumBold, color: .Base.black)
                .frame(width: freeLabelSize != 0 ? freeLabelSize : nil)
        }
    }
    
    func comparisonRowView(_ comparison: PaywallComparisonUIModel) -> some View {
        HStack(spacing: .small) {
            Text(comparison.title.localized)
                .font(.Body.small, color: .Base.black)
                .fullWidth(.leading)
            
            comparisonValueView(comparison.free, isMax: false)
                .frame(width: freeLabelSize != 0 ? freeLabelSize : nil)
            
            comparisonValueView(comparison.max)
                .frame(width: freeLabelSize != 0 ? freeLabelSize : nil)
        }
    }
    
    @ViewBuilder
    func comparisonValueView(_ value: Int?, isMax: Bool = true) -> some View {
        Group {
            switch value {
            case nil:
                Text("-")
            case 0:
                CircleCheckmarkView(isColored: isMax)
            default:
                Text(value?.formatted() ?? "-")
            }
        }
        .font(.Body.mediumBold, color: .Secondary.secondary300)
    }
    
}

// MARK: - Preview
#Preview {
    PaywallComparisonSectionView(comparisons: [.mock1, .mock2])
        .padding()
}
