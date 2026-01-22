//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 21/01/2026.
//

import SwiftUI
import Core

public struct DismissButtonView: View {
    
    private let dismissAction: (() async -> Void)?
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Init
    public init(
        dismissAction: (() async -> Void)? = nil
    ) {
        self.dismissAction = dismissAction
    }
    
    // MARK: - View
    public var body: some View {
        Button {
            VibrationManager.vibration()
            if let dismissAction {
                Task {
                    await dismissAction()
                }
            } else {
                dismiss()
            }
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
