//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 21/01/2026.
//

import SwiftUI

public struct DismissButtonView: View {
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Init
    public init() { }
    
    // MARK: - View
    public var body: some View {
        Button {
            dismiss()
        } label: {
            IconView(asset: .iconXmark, size: .small, color: .Text.secondary)
                .padding(6)
                .background(Color.Background.bg100, in: .circle)
        }
    }
}

// MARK: - Preview
#Preview {
    DismissButtonView()
}
