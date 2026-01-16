//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 16/01/2026.
//

import SwiftUI

public enum BigValueStyle {
    case neutral, good, bad
    
    var primaryColor: Color {
        switch self {
        case .neutral: return .Text.primary
        case .good: return .Primary.p500
        case .bad: return .Red.r500
        }
    }
}

public struct BigValueView: View {
    
    // MARK: Dependencies
    private let style: BigValueStyle
    private let amount: Double
    private let text: String
    private let alignment: HorizontalAlignment
    
    // MARK: Init
    public init(
        style: BigValueStyle = .neutral,
        amount: Double,
        text: String,
        alignment: HorizontalAlignment = .leading
    ) {
        self.style = style
        self.amount = amount
        self.text = text
        self.alignment = alignment
    }
    
    // MARK: - View
    public var body: some View {
        VStack(alignment: alignment, spacing: .zero) {
            Text(amount.toCurrency())
                .font(.Title.large, color: style.primaryColor)
            
            Text(text)
                .font(.Body.small, color: .Text.secondary)
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: .small) {
        BigValueView(style: .bad, amount: -48.0, text: "Bad expenses")
        BigValueView(style: .good, amount: 512.0, text: "Good expenses", alignment: .center)
    }
    .padding(.standard)
}
