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
    
    @EnvironmentObject private var router: Router<AppDestination>
    
    // MARK: - View
    var body: some View {
        VStack(spacing: .large) {
            Button {
                
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
                    route: .sheet,
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
