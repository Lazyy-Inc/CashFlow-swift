//
//  ToolbarDismissKeyboardButtonView.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/02/2024.
//

import SwiftUI
import Core

public struct ToolbarDismissKeyboardButtonView: ToolbarContent {
    
    @Environment(\.theme) private var theme
    
    public init() {}
    
    // MARK: - body
    public var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                EmptyView()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Button(action: {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }, label: {
                    Image(systemName: "keyboard.chevron.compact.down.fill")
                        .foregroundStyle(theme.color)
                })
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
        }
    } // End body
} // End struct
