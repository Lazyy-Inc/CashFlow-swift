//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI

public struct CircleCheckmarkView: View {
    
    // MARK: Dependencies
    private let isColored: Bool
    
    // MARK: Init
    public init(isColored: Bool = true) {
        self.isColored = isColored
    }
    
    // MARK: - View
    public var body: some View {
        IconView(asset: .iconCheck, size: .extraSmall, color: .Base.white)
            .padding(6)
            .background(backgroundColor, in: .circle)
    }

    var backgroundColor: AnyShapeStyle {
        return isColored ? AnyShapeStyle(LinearGradient.main) : AnyShapeStyle(Color.Secondary.secondary400)
    }
}

// MARK: - Preview
#Preview {
    CircleCheckmarkView()
}
