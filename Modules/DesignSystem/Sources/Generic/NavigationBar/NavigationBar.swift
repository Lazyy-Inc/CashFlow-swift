//
//  NavigationBar.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/05/2025.
//

import SwiftUI
import TheoKit
import Core

public struct NavigationBar: View {
    
    public var title: String?
    public var withDismiss: Bool = true
    public var actionButton: NavigationBar.ActionButton?
    public var dismissAction: (() -> Void)?

    public var placeholder: String = ""
    @Binding public var searchText: String
    
    public init(
        title: String? = nil,
        withDismiss: Bool = true,
        actionButton: NavigationBar.ActionButton? = nil,
        dismissAction: (() -> Void)? = nil,
        placeholder: String = "",
        searchText: Binding<String> = .constant("")
    ) {
        self.title = title
        self.withDismiss = withDismiss
        self.actionButton = actionButton
        self.dismissAction = dismissAction
        self.placeholder = placeholder
        self._searchText = searchText
    }
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.standard) {
            VStack(alignment: .leading, spacing: Spacing.small) {
                HStack(spacing: Spacing.small) {
                    if withDismiss {
                        HStack(spacing: Spacing.extraSmall) {
                            Button {
                                if let dismissAction {
                                    dismissAction()
                                } else {
                                    dismiss()
                                }
                            } label: {
                                Image("iconArrowLeft")
                                    .resizable()
                                    .renderingMode(.template)
                                    .frame(width: 20, height: 20)
                                Text("word_return".localized)
                                    .fontWithLineHeight(.Body.medium)
                            }
//                            .glassButtonEffect()
                        }
                        .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                    }
                    
                    if let actionButton {
                        Button {
                            Task {
                                await actionButton.action()
                            }
                        } label: {
                            if let icon = actionButton.icon {
                                Image(icon)
                                    .renderingMode(.template)
                                    .foregroundStyle(Color.label)
                            } else if let title = actionButton.title {
                                Text(title)
                                    .fontWithLineHeight(.Body.large)
                                    .foregroundStyle(theme.color)
                            }
                        }
//                        .glassButtonEffect()
                        .fullWidth(.trailing)
                        .disabled(actionButton.isDisabled)
                        .opacity(actionButton.isDisabled ? 0.5 : 1)
                    }
                }
                
                if let title {
                    Text(title)
                        .fontWithLineHeight(.Title.large)
                        .foregroundStyle(Color.label)
                }
            }
            
            if !placeholder.isEmpty {
                SearchBarView(placeholder, searchText: $searchText)
            }
        }
        .fullWidth(.leading)
        .padding(Padding.large)
    } // body
} // struct

extension NavigationBar {
    
    public struct ActionButton {
        public var title: String?
        public var icon: String?
        public var action: () async -> Void
        public var isDisabled: Bool = true
        
        public init(
            title: String? = nil,
            icon: String? = nil,
            action: @escaping () async -> Void,
            isDisabled: Bool = false
        ) {
            self.title = title
            self.icon = icon
            self.action = action
            self.isDisabled = isDisabled
        }
    }
    
}

// MARK: - Preview
#Preview {
    NavigationBar(
        title: "Preview Test",
        actionButton: .init(
            title: "Create",
            action: { }
        )
    )
}
