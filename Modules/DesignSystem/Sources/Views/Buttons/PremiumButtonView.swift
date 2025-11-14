//
//  PremiumButtonView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import Navigation
import Core

public struct PremiumButtonView: View {
    
    @Environment(\.theme) private var theme
    
    public init() {}
    
    // MARK: -
    public var body: some View {
        NavigationButtonView(
            route: .fullScreenCover,
            destination: AppDestination.shared(.paywall)
        ) {
            HStack(spacing: 4) {
                Text("Pro")
                    .font(.semiBoldText16())
                Image(systemName: "crown.fill")
                    .font(.system(size: 14))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .foregroundStyle(Color.white)
            .background {
                Capsule()
                    .fill(theme.color)
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PremiumButtonView()
}
