//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI

struct TabbarItemView: View {
    
    // MARK: Dependencies
    let icon: String
    let text: String
    let isSelected: Bool
    
    // MARK: - View
    var body: some View {
        VStack(spacing: Spacing.extraSmall) {
            IconSVG(icon: icon, value: .large)
            Text(text.localized)
                .font(.Label.medium)
        }
        .foregroundStyle(isSelected ? Color.primary500 : Color.text)
    }
    
}

// MARK: - Preview
#Preview {
    TabbarItemView(
        icon: "iconHouse",
        text: "Accueil",
        isSelected: false
    )
}
