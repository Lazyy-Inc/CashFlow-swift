//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 24/10/2025.
//

import SwiftUI

public struct AmountAfterView: View {
    
    // MARK: Dependencies
    let title: String
    
    let leftText: String
    let leftValue: String
    
    let rightText: String?
    let rightValue: String?
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    
    // MARK: Init
    public init(
        title: String,
        leftText: String,
        leftValue: String,
        rightText: String? = nil,
        rightValue: String? = nil,
    ) {
        self.title = title
        self.leftText = leftText
        self.leftValue = leftValue
        self.rightText = rightText
        self.rightValue = rightValue
    }
    
    // MARK: - View
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.medium) {
            Text(title)
                .font(.Title.medium)
                .fullWidth(.leading)
            
            HStack(spacing: Spacing.standard) {
                VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                    Text(leftText)
                        .font(.Body.medium)
                        .foregroundStyle(theme.color)
                    Text(leftValue)
                        .font(.Body.large)
                        .contentTransition(.numericText())
                }
                .fullWidth(.leading)
                
                if let rightText, let rightValue {
                    IconSVG(icon: "iconArrowRight", value: .large)
                        .foregroundStyle(Color.Background.bg600)
                    
                    VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                        Text(rightText)
                            .font(.Body.medium)
                            .foregroundStyle(theme.color)
                        Text(rightValue)
                            .font(.Body.large)
                            .contentTransition(.numericText())
                    }
                    .fullWidth(.leading)
                }
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    AmountAfterView(
        title: "Montant après transaction",
        leftText: "Trade Republic",
        leftValue: "4 112 €"
    )
}
