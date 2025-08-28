//
//  DetailRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/12/2024.
//

import SwiftUI
import TheoKit

public struct DetailRow: View {
    
    // Builder
    var icon: String
    var text: String?
    var value: String
    var iconBackgroundColor: Color = Color.Background.bg200
    var action: (() -> Void)?
    
    public init(
        icon: String,
        text: String? = nil,
        value: String,
        iconBackgroundColor: Color = Color.Background.bg200,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.text = text
        self.value = value
        self.iconBackgroundColor = iconBackgroundColor
        self.action = action
    }
    
    // MARK: -
    public var body: some View {
        Button {
            if let action { action() }
        } label: {
            HStack(spacing: 8) {
                IconSVG(icon: icon, value: .small)
                    .foregroundStyle(Color.white)
                    .padding(6)
                    .background {
                        Circle()
                            .fill(iconBackgroundColor)
                    }
                if let text {
                    Text(text)
                        .fontWithLineHeight(.Body.small)
                        .foregroundStyle(Color.label)
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: true)
                }
                
                Text(value)
                    .fontWithLineHeight(.Body.medium)
                    .foregroundStyle(Color.label)
                    .multilineTextAlignment(.trailing)
                    .fullWidth(.trailing)
            }
            .padding()
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.standard,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        DetailRow(
            icon: "iconShirt",
            value: "Vêtements, Chaussures, Accessoires",
            iconBackgroundColor: Color.red
        )
        
        DetailRow(
            icon: "iconCalendar",
            text: "Date",
            value: "Vêtements, Chaussures, Accessoires",
            iconBackgroundColor: Color.red
        )
    }
    .padding()
    .background(Color.Background.bg50)
}
