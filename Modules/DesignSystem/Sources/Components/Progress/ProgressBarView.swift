//
//  ProgressBarView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import Core

public struct ProgressBarView: View {
    
    // MARK: Dependencies
    let percentage: Double
    let config: Configuration
    
    // MARK: Environment
    @Environment(\.theme) private var theme
    
    // MARK: States
    @State private var isAnimated: Bool = false
    @State private var widthPercentage: CGFloat = 0
    
    // MARK: Init
    public init(percentage: Double, config: Configuration = .init()) {
        self.percentage = percentage
        self.config = config
    }
    
    // MARK: - View
    public var body: some View {
        GeometryReader { geometry in
            RoundedRectangle(cornerRadius: config.radius, style: .continuous)
                .fill(config.backgroundColor)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: config.radius, style: .continuous)
                        .fill(theme.color)
                        .frame(width: isAnimated ? progressWidth : 0)
                        .overlay(alignment: .trailing) {
                            Text(percentageString)
                                .font(.Body.mediumBold, color: .Text.primaryReversed)
                                .opacity(isAnimated ? 1 : 0)
                                .padding(.horizontal, 12)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .animation(.smooth.delay(0.3), value: progressWidth)
                        .animation(.smooth.delay(0.3), value: isAnimated)
                }
                .overlay {
                    RoundedRectangle(cornerRadius: config.radius, style: .continuous)
                        .stroke(config.strokeColor, style: .init(lineWidth: 1))
                }
                .onAppear {
                    isAnimated = true
                    widthPercentage = geometry.size.width * min(1, percentage)
                }
        }
    }
}

// MARK: - Computed variables
extension ProgressBarView {
    
    private var percentageString: String {
        let percentage = percentage * 100
        return percentage.toString(maxDigits: 0) + " %"
    }
    
    private var progressWidth: CGFloat {
        return max(80, widthPercentage)
    }
    
}

// MARK: - Configuration
extension ProgressBarView {
    
    public struct Configuration {
        let radius: CGFloat
        let backgroundColor: Color
        let strokeColor: Color
        
        public init(
            radius: CGFloat = CornerRadius.medium,
            backgroundColor: Color = Color.Background.bg100,
            strokeColor: Color = Color.Background.bg200
        ) {
            self.radius = radius
            self.backgroundColor = backgroundColor
            self.strokeColor = strokeColor
        }
    }
    
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        ProgressBarView(percentage: 1)
            .frame(height: 48)
        ProgressBarView(percentage: 0.01)
            .frame(height: 48)
    }
    .padding()
    .background(Color.Background.bg50)
}
