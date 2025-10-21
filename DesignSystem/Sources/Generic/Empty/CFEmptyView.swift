//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import SwiftUI
import Navigation
import Models

public struct CFEmptyView: View {
    
    // MARK: Dependencies
    var type: EmptyViewType
    
    // MARK: Environments
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: Init
    public init(type: EmptyViewType) {
        self.type = type
    }
    
    // MARK: - View
    public var body: some View {
        Button { type.action(router: router) } label: {
            VStack(spacing: Spacing.small) {
                IconSVG(icon: type.icon, value: .extraLarge)
                    .foregroundStyle(Color.Background.bg600)
                
                VStack(spacing: Spacing.extraSmall) {
                    Text(type.title.localized)
                        .fontWithLineHeight(.Body.large)
                        .foregroundStyle(Color.label)
                    
                    Text(type.description.localized)
                        .fontWithLineHeight(.Body.small)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(Color.Background.bg500)
                }
                
                Text(type.buttonTitle.localized)
                    .fontWithLineHeight(.Label.large)
                    .foregroundStyle(Color.white)
                    .padding(.horizontal, Spacing.medium)
                    .padding(.vertical, Spacing.small)
                    .background(
                        LinearGradient.main,
                        in: .rect(cornerRadius: CornerRadius.medium, style: .continuous)
                    )
            }
            .fullWidth()
            .padding(Spacing.large)
            .roundedRectangleBorder(
                Color.Background.bg100,
                radius: CornerRadius.large,
                lineWidth: 1,
                strokeColor: Color.Background.bg200
            )
        }

    }
}

extension EmptyViewType {
    
    func action(router: Router<AppDestination>) {
        switch self {
        case .noAccounts:
            router.push(.account(.create))
        case .noTransactions:
            router.push(.transaction(.create))
        case .noBudgets:
            router.push(.budget(.create))
        case .noSubscriptions:
            router.push(.subscription(.create))
        case .noFinancialGoals:
            router.push(.savingsPlan(.create))
        case .noSavingsAccounts:
            router.push(.savingsAccount(.create))
        }
    }
    
}

// MARK: - Preview
#Preview {
    CFEmptyView(type: .noTransactions)
        .padding()
        .background(Color.Background.bg50)
}
