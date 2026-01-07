//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 20/10/2025.
//

import SwiftUI

public struct ClassicRowView: View {
    
    // MARK: Dependencies
    let text: String
    
    // MARK: Init
    public init(text: String) {
        self.text = text
    }
    
    // MARK: - View
    public var body: some View {
        HStack {
            Text(text)
                .font(.Body.medium)
                .foregroundStyle(Color.label)
                .fullWidth(.leading)
            
            IconSVG(icon: "iconArrowRight", value: .large)
                .foregroundStyle(Color.Background.bg600)
        }
        .padding(Spacing.standard)
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    }
}

// MARK: - Preview
#Preview {
    ClassicRowView(text: "Hello World!")
        .padding()
        .background(Color.Background.bg50)
}
