//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 24/07/2025.
//

import SwiftUI
import Core

public enum ActionButtonStyle {
    case plain
    case secondary
    case disabled
    
    var foregroundColor: Color {
        switch self {
        case .plain:
            return .white
        case .secondary:
            return .Text.primary
        case .disabled:
            return .white.opacity(0.3)
        }
    }
    
    var backgroundColor: AnyShapeStyle {
        switch self {
        case .plain:
            return AnyShapeStyle(LinearGradient.main)
        case .secondary:
            return AnyShapeStyle(Color.Background.bg200)
        case .disabled:
            return AnyShapeStyle(LinearGradient.main.opacity(0.3))
        }
    }
}

public struct ActionButtonView: View {
    
    // MARK: Dependencies
    let style: ActionButtonStyle
    let title: String
    let action: () async -> Void
    
    // MARK: States
    @State private var isLoading: Bool = false
    
    // MARK: Init
    public init(
        style: ActionButtonStyle = .plain,
        title: String,
        action: @escaping () async -> Void
    ) {
        self.style = style
        self.title = title
        self.action = action
    }
    
    // MARK: - View
    public var body: some View {
        Button {
            Task {
                isLoading = true
                await action()
                isLoading = false
            }
        } label: {
            Group {
                if isLoading {
                    ProgressView()
                } else {
                    Text(title)
                        .font(.Body.mediumBold, color: style.foregroundColor)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Padding.standard)
            .background(style.backgroundColor, in: .rect(cornerRadius: CornerRadius.standard, style: .continuous))
            .animation(.smooth, value: isLoading)
        }
        .disabled(isLoading || style == .disabled)
    }
}

// MARK: - Preview
#Preview {
    ActionButtonView(style: .plain, title: "Preview") { }
    ActionButtonView(style: .disabled, title: "Preview") { }
}
