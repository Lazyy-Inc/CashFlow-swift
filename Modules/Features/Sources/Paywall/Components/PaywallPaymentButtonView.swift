//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import DesignSystem
import Core

struct PaywallPaymentButtonView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @StateObject private var purchasesManager: PurchasesManager = .shared
    
    // MARK: - View
    var body: some View {
        if let lifetime = purchasesManager.lifetime {
            VStack(spacing: .medium) {
                if purchasesManager.isCashFlowPro {
                    ActionButtonView(
                        title: "paywall_purchased".localized
                    ) {
                        dismiss()
                    }
                } else {
                    VStack(spacing: .small) {
                        HStack(spacing: .small) {
                            Text("paywall_lifetime".localized)
                                .font(.Body.medium, color: .Base.black)
                            
                            promotionCapsuleView
                            
                            Spacer()
                            
                            Text((lifetime.price*2).toCurrency())
                                .font(.Body.medium, color: .Secondary.secondary400)
                                .strikethrough()
                            
                            Text(lifetime.displayPrice)
                                .font(.Body.medium, color: .Base.black)
                        }
                        .padding(.standard)
                        .roundedBackground(.classic)
                        
                        ActionButtonView(
                            title: "generic_continue".localized
                        ) {
                            await purchasesManager.buyProduct(lifetime)
                        }
                    }
                    
                    Text("paywall_footer_sentence".localized)
                        .font(.Body.small, color: .Secondary.secondary400)
                }
            }
            .padding(.horizontal, .standard)
            .padding(.top, .standard)
            .padding(.bottom, .huge)
            .background(Color.Background.bg50, in: .rect(topLeadingRadius: .standard, topTrailingRadius: .standard))
            .shadow(radius: 60, y: -4)
        }
    }
}

// MARK: - Subviews
extension PaywallPaymentButtonView {
    
    private var promotionCapsuleView: some View {
        Text("paywall_promotion".localized)
            .font(.Label.large, color: .Red.r500)
            .padding(.horizontal, .small)
            .padding(.vertical, 4)
            .background(Color.Red.r100, in: Capsule())
    }
    
}

// MARK: - Preview
#Preview {
    PaywallPaymentButtonView()
}
