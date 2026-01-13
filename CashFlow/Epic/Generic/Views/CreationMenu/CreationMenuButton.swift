//
//  CreationMenuButton.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Navigation
import Core
import DesignSystem

struct CreationMenuAction: Identifiable {
    let id = UUID()
    let title: String
    let icon: ImageResource
    let destination: AppDestination
    let isDisabled: Bool
    let onTapAction: (() -> Void)?
    
    init(
        title: String,
        icon: ImageResource,
        destination: AppDestination,
        isDisabled: Bool = false,
        onTapAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.destination = destination
        self.isDisabled = isDisabled
        self.onTapAction = onTapAction
    }
}

struct CreationMenuButton: View {
    let action: CreationMenuAction
    let onPress: () -> Void
    
    var body: some View {
        Button {
            onPress()
            AppRouterManager.shared.router(for: AppManager.shared.selectedTab)?.push(action.destination)
        } label: {
            Label {
                Text(action.title)
                    .font(.Title.medium)
            } icon: {
                Image(action.icon)
                    .renderingMode(.template)
            }
            .foregroundStyle(Color.Text.primary)
            .padding(.horizontal, Spacing.standard)
            .padding(.vertical, Spacing.medium)
            .roundedRectangleBorder(
                Color.Background.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: Color.Background.bg200
            )
        }
        .disabled(action.isDisabled)
        .onTapGesture {
            action.onTapAction?()
        }
    }
}

// MARK: - Preview
#Preview {
    CreationMenuButton(
        action: .init(
            title: "Preview",
            icon: .iconPerson,
            destination: .transaction(.create)
        ),
        onPress: { }
    )
}
