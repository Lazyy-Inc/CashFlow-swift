//
//  ProgressBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import Core

public struct ProgressBar: View {
    
    // Builder
    var percentage: Double
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    @State private var isAnimated: Bool = false
    
    var percentageString: String {
        let percentage = percentage * 100
        return percentage.toString(maxDigits: 0) + " %"
    }
    
    public init(percentage: Double) {
        self.percentage = percentage
    }
    
    // MARK: -
    public var body: some View {
        GeometryReader { geometry in
            let widthText = percentageString.width(usingFont: UIFont(name: "PlusJakartaSans-SemiBold", size: 16)!) * 1.8 // TODO: Need refactor
            let widthPercentage = geometry.size.width * min(1, percentage)
            let progressWidth = max(widthText, widthPercentage)
            
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Background.bg100)
                .overlay(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(themeManager.theme.color)
                        .frame(width: isAnimated ? progressWidth : 0)
                        .overlay(alignment: .trailing) {
                            Text(percentageString)
                                .opacity(isAnimated ? 1 : 0)
                                .padding(.trailing, 12)
                                .font(.semiBoldText16())
                                .foregroundStyle(Color(uiColor: .systemBackground))
                                .padding(.leading, 12)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .animation(.smooth.delay(0.3), value: progressWidth)
                        .animation(.smooth.delay(0.3), value: isAnimated)
                }
                .onAppear {
                    isAnimated = true
                }
        }
    } // body
} // struct

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
    .environmentObject(ThemeManager())
}
