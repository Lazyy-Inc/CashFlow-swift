//
//  SettingsAppearenceView.swift
//  CashFlow
//
//  Created by Theo Sementa on 25/02/2024.
//

import SwiftUI
import Core

public struct SettingsAppearenceView: View {
                
    public init() { }
    
    // MARK: -
    public var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                HStack(spacing: 16) {
                    ThemeCell(type: .system)
                    ThemeCell(type: .light)
                    ThemeCell(type: .dark)
                }
                
                SelectThemeColor()
                
                SelectAppIcon()
            }
            .padding()
        } // ScrollView
        .scrollIndicators(.hidden)
        .scrollContentBackground(.hidden)
        .background(Color.Background.bg50)
        .navigationBarTitleDisplayMode(.inline)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsAppearenceView()
        .environmentObject(AppearanceManager())
}
