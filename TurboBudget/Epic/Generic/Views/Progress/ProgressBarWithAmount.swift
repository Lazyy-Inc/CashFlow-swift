//
//  ProgressBarWithAmount.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI
import Core
import DesignSystem

struct ProgressBarWithAmount: View {
    
    // MARK: Dependencies
    var percentage: Double
    var value: Double
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    
    // MARK: States
    @State private var valueWidth: CGFloat = 0
    @State private var widthPercentage: CGFloat = 0
    
    // MARK: Computed variables
    var valueString: String {
        return value.formattedAbbreviatedCurrency()
    }
    
    var progressWidth: CGFloat {
        max(valueWidth, widthPercentage)
    }
    
    // MARK: - View
    var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color.Background.bg200)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(theme.color)
                        .frame(width: progressWidth)
                        .overlay(alignment: .trailing) {
                            Text(valueString)
                                .fontWithLineHeight(.Label.large)
                                .foregroundStyle(Color.textReversed)
                                .getSize { valueWidth = $0.width }
                                .opacity(progressWidth != 0 ? 1 : 0)
                                .padding(.horizontal, 8)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .animation(.smooth.delay(0.3), value: progressWidth)
                }
                .onAppear {
                    widthPercentage = geometry.size.width * min(1, percentage)
                }
        }
    }
}

// MARK: - Preview
#Preview {
    ProgressBarWithAmount(percentage: 0.4, value: 300)
        .frame(height: 38)
        .padding()
        .background(Color.Background.bg50)
}
