//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI
import Navigation

public struct TabbarView: View {
    
    // MARK: Dependencies
    @Binding var selectedTab: AppTabs
    
    public init(selectedTab: Binding<AppTabs>) {
        self._selectedTab = selectedTab
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: 0) {
            ForEach(AppTabs.allCases, id: \.self) { tab in
                Button { selectedTab = tab } label: {
                    TabbarItemView(
                        icon: tab.icon,
                        text: tab.text,
                        isSelected: selectedTab.rawValue == tab.rawValue
                    )
                    .fullWidth()
                }
            }
        }
        .padding(.bottom, Spacing.extraLarge)
        .padding(.top, Spacing.standard)
        .background(
            RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous)
                .fill(Color.Background.bg100)
                .overlay(
                    RoundedRectangle(cornerRadius: CornerRadius.large, style: .continuous)
                        .strokeBorder(Color.Background.bg200, lineWidth: 1)
                )
        )
    }
    
}

// MARK: - Preview
#Preview {
    TabbarView(selectedTab: .constant(.subscriptions))
}
