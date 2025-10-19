//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI

public struct PlusButtonView: View {
    
    // MARK: Dependencies
    let action: () -> Void
    
    // MARK: Init
    public init(action: @escaping () -> Void) {
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button(action: action) {
            IconSVG(icon: "iconPlus", value: .large)
                .foregroundStyle(Color.white)
                .padding(Spacing.medium)
                .background(LinearGradient.main, in: Circle())
        }
    }
}

// MARK: - Preview
#Preview {
    PlusButtonView() { }
}
