//
//  NavigationBarWithMenu.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/05/2025.
//

import SwiftUI

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
                        IconView(asset: .iconArrowLeft, size: .medium, color: .Text.secondary)
                        Text("word_return".localized)
                            .font(.Body.medium, color: .Text.secondary)
                    }
//                    .glassButtonEffect()
                }
                
                if let title {
                    Text(title)
                        .font(.Title.large, color: .Text.primary)
                }
            }
            
            Spacer()
            
            Menu(content: content) {
                IconView(asset: .iconEllipsis, color: .Text.primary)
            }
//            .glassButtonEffect()
        }
        .padding(.horizontal, Padding.large)
    }
}

// MARK: - Preview
#Preview {
    NavigationBarWithMenu {
        
    }
}
