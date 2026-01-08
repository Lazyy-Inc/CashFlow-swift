//
//  ProgressCircle.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/12/2024.
//

import SwiftUI

public struct ProgressCircle: View {
    
    // Builder
    var value: Double
    var percentage: Double
    var color: Color
    
    public init(
        value: Double,
        percentage: Double,
        color: Color
    ) {
        self.value = value
        self.percentage = percentage
        self.color = color
    }
    
    // MARK: -
    public var body: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 20))
                .foregroundStyle(color.opacity(0.5))
            Circle()
                .trim(from: 0, to: value)
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundStyle(color)
                .rotationEffect(.degrees(-90))
            Text(String(format: "%.1f", percentage) + "%")
                .font(.Body.small)
        }
    }
}

// MARK: - Preview
#Preview {
    ProgressCircle(
        value: 0.7,
        percentage: 34.5,
        color: .red
    )
}
