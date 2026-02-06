//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 06/02/2026.
//

import SwiftUI
import Models

public struct DetailRowView: View {
    
    // MARK: Dependencies
    private let icon: ImageType
    private let iconColor: Color
    private let text: String?
    private let value: String
    private let valueColor: Color
    
    // MARK: Init
    public init(
        icon: ImageType,
        iconColor: Color = .Text.primary,
        text: String? = nil,
        value: String,
        valueColor: Color = .Text.primary
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.text = text
        self.value = value
        self.valueColor = valueColor
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: .small) {
            HStack(spacing: .small) {
                IconView(asset: icon, color: iconColor)
                Text(text ?? "")
                    .font(.Body.medium)
            }
            
            Text(value)
                .font(.Body.mediumBold, color: valueColor)
                .multilineTextAlignment(.trailing)
                .fullWidth(.trailing)
        }
    }
    
}

// MARK: - Preview
#Preview {
    DetailRowView(
        icon: .iconAlert,
        value: "This is an alert"
    )
}
