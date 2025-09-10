//
//  NavigationBarWithMenu.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/05/2025.
//

import SwiftUI
import TheoKit

public struct NavigationBarWithMenu<Content: View>: View {
    
    // MARK: Dependencies
    var title: String?
    @ViewBuilder var content: () -> Content
    var dismissAction: (() -> Void)?
    
    @Environment(\.dismiss) private var dismiss
    
    public init(
        title: String? = nil,
        dismissAction: (() -> Void)? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.dismissAction = dismissAction
        self.content = content
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.small) {
            VStack(alignment: .leading, spacing: Spacing.small) {
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
                    .glassButtonEffect()
                }
                .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
                
                if let title {
                    Text(title)
                        .fontWithLineHeight(.Title.large)
                        .foregroundStyle(Color.label)
                }
            }
            
            Spacer()
            
            Menu(content: content) {
                Image("iconEllipsis")
                    .renderingMode(.template)
                    .foregroundStyle(Color.label)
            }
            .glassButtonEffect()
        }
        .padding(.horizontal, Padding.large)
    }
}

// MARK: - Preview
#Preview {
    NavigationBarWithMenu {
        
    }
}
