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
                .font(.Label.medium, color: isSelected ? Color.Primary.p500 : Color.Text.primary)
        }
        .foregroundStyle(isSelected ? Color.Primary.p500 : Color.Text.primary)
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
