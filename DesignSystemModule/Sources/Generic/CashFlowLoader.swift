//
//  CashFlowLoader.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import Core

public struct CashFlowLoader: View {
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    public init() {}
    
    // MARK: -
    public var body: some View {
        ProgressView()
            .tint(Color.white)
            .padding()
            .background(
                Circle()
                    .fill(themeManager.theme.color)
            )
    } // body
} // struct

// MARK: - Preview
#Preview {
    CashFlowLoader()
        .environmentObject(ThemeManager.shared)
}
