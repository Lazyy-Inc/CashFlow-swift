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
    case disabled
    
    public var backgroundColor: AnyShapeStyle {
        switch self {
        case .plain:
            return AnyShapeStyle(LinearGradient(
                colors: [Color.Primary.p500, Color.Primary.p500.darker(by: 15)],
                startPoint: .top,
                endPoint: .bottom
            ))
        case .disabled:
            return AnyShapeStyle(LinearGradient(
                colors: [Color.Primary.p500, Color.Primary.p500.darker(by: 15)],
                startPoint: .top,
                endPoint: .bottom
            ).opacity(0.3))
        }
    }
}

public struct ActionButtonView: View {
    
    // MARK: Dependencies
    let style: ActionButtonStyle
    let title: String
    let action: () async -> Void
    
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
                        .font(.Body.mediumBold, color: .white)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(Padding.standard)
            .background(style.backgroundColor, in: .rect(cornerRadius: CornerRadius.large, style: .continuous))
            .animation(.smooth, value: isLoading)
        }
        .disabled(isLoading)
    }
}

// MARK: - Preview
#Preview {
    ActionButtonView(style: .plain, title: "Preview") { }
    ActionButtonView(style: .disabled, title: "Preview") { }
}
