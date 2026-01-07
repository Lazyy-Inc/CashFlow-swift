//
//  FocusOnTapModifier.swift
//  DesignSystem
//
//  Created by Theo Sementa on 05/01/2026.
//

import SwiftUI

struct FocusOnTapModifier: ViewModifier {
    
    // MARK: States
    @FocusState private var isFocused: Bool
    
    // MARK: - View
    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onTapGesture {
                isFocused = true
            }
    }
    
}

public extension View {
    
    func focusOnTap() -> some View {
        return modifier(FocusOnTapModifier())
    }
    
}
