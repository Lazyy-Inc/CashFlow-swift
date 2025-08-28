//
//  ToolbarDismissButtonView.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/02/2024.
//

import SwiftUI
import Core

public struct ToolbarDismissButtonView: ToolbarContent {
    
    // Builder
    var action: () -> Void
    
    @EnvironmentObject private var themeManager: ThemeManager
    
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: - body
    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button(action: action, label: {
                Text("word_cancel".localized)
                    .font(.regularText16())
                    .foregroundStyle(themeManager.theme.color)
            })
        }
    } // End body
} // End struct
