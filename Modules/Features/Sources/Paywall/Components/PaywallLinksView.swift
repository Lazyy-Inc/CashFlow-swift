//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import DesignSystem
import Models
import Navigation
import Core

struct PaywallLinksView: View {
    
    @Environment(Router<AppDestination>.self) private var router
    @EnvironmentObject private var purchasesManager: PurchasesManager
    
    // MARK: - View
    var body: some View {
        VStack(spacing: .large) {
            AsyncButton {
                await purchasesManager.restorePurchases()
            } label: {
                Label(title: {
                    Text("paywall_link_restore_purchase".localized)
                        .font(.Body.mediumBold, color: .Base.white)
                }, icon: {
                    IconView(asset: .iconArrowRotation, color: .Base.white)
                })
            }
            
            if let url = URL(string: AppConstantType.appEULA) {
                NavigationButtonView(
                    route: .sheet(style: .large),
                    destination: .shared(.sfSafari(url: url))
                ) {
                    Label(title: {
                        Text("paywall_link_conditions".localized)
                            .font(.Body.mediumBold, color: .Base.white)
                    }, icon: {
                        IconView(asset: .iconFileText, color: .Base.white)
                    })
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallLinksView()
}
