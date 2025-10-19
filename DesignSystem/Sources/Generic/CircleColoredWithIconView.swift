//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI

public struct CircleColoredWithIconView: View {
    
    // MARK: Dependencies
    let circleColor: Color
    let icon: String
    let iconColor: Color
    
    // MARK: Init
    public init(circleColor: Color, icon: String, iconColor: Color) {
        self.circleColor = circleColor
        self.icon = icon
        self.iconColor = iconColor
    }
    
    // MARK: - View
    public var body: some View {
        Circle()
            .foregroundStyle(circleColor)
            .frame(width: 36, height: 36)
            .overlay {
                IconSVG(icon: icon, value: .medium)
                    .foregroundStyle(iconColor)
            }
    }
}

// MARK: - Preview
#Preview {
    CircleColoredWithIconView(
        circleColor: .red,
        icon: "iconCat",
        iconColor: .white
    )
}
