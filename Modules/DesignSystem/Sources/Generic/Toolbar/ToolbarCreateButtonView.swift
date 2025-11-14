//
//  ToolbarCreateButtonView.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/02/2024.
//

import SwiftUI
import Core
import Models

public struct ToolbarValidationButtonView: ToolbarContent {
    
    // Builder
    var type: ValidationButtonType = .creation
    var isActive: Bool
    var action: () async -> Void
    
    @Environment(\.theme) private var theme
    
    @State private var isLoading: Bool = false
    
    public init(
        type: ValidationButtonType = .creation,
        isActive: Bool = true,
        action: @escaping () async -> Void
    ) {
        self.type = type
        self.isActive = isActive
        self.action = action
    }
    
    // MARK: - body
    public var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                Task {
                    isLoading = true
                    await action()
                    isLoading = false
                }
            }, label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text(type == .creation ? Word.Classic.create : Word.Classic.edit)
                        .font(.boldText16())
                        .foregroundStyle(theme.color)
                }
            })
            .disabled(!isActive || isLoading)
            .opacity(isActive ? 1 : 0.5)
        }
    } // End body
} // End struct
