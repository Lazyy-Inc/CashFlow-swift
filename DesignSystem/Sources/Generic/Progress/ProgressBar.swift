//
//  ProgressBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import Core

public struct ProgressBar: View {
    
    // MARK: Dependencies
    var percentage: Double
    
    // MARK: Environment
    @Environment(\.theme) private var theme
    
    // MARK: States
    @State private var isAnimated: Bool = false
    @State private var valueWidth: CGFloat = 0
    @State private var widthPercentage: CGFloat = 0
    
    // MARK: Computed variables
    var percentageString: String {
        let percentage = percentage * 100
        return percentage.toString(maxDigits: 0) + " %"
    }
    
    var progressWidth: CGFloat {
        max(valueWidth, widthPercentage)
    }
    
    // MARK: Init
    public init(percentage: Double) {
        self.percentage = percentage
    }
    
    // MARK: - View
    public var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Background.bg100)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(theme.color)
                        .frame(width: isAnimated ? progressWidth : 0)
                        .overlay(alignment: .trailing) {
                            Text(percentageString)
                                .fontWithLineHeight(.Body.mediumBold)
                                .getSize { valueWidth = $0.width }
                                .foregroundStyle(Color.textReversed)
                                .opacity(isAnimated ? 1 : 0)
                                .padding(.horizontal, 12)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .animation(.smooth.delay(0.3), value: progressWidth)
                        .animation(.smooth.delay(0.3), value: isAnimated)
                }
                .onAppear {
                    isAnimated = true
                    widthPercentage = geometry.size.width * min(1, percentage)
                }
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        ProgressBar(percentage: 1)
            .frame(height: 48)
        ProgressBar(percentage: 0.48)
            .frame(height: 48)
    }
    .padding()
    .background(Color.Background.bg50)
}
