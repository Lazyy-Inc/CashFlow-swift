//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI
import Models

public struct CircleColoredWithIconView: View {
    
    // MARK: Dependencies
    let circleColor: Color
    let icon: String
    let iconColor: Color
    
    // MARK: Init
    public init(
        circleColor: Color,
        icon: String,
        iconColor: Color = .Base.white
    ) {
        self.circleColor = circleColor
        self.icon = icon
        self.iconColor = iconColor
    }
    
    // MARK: - View
    public var body: some View {
        IconView(asset: ImageType(rawValue: icon) ?? .iconAlert, size: .medium, color: iconColor)
            .padding(.small)
            .background(circleColor, in: .circle)
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
