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
    
    @StateObject private var purchasesManager: PurchasesManager = .shared
    
    // MARK: - View
    var body: some View {
        if let lifetime = purchasesManager.lifetime {
            VStack(spacing: .medium) {
                if purchasesManager.isCashFlowPro {
                    ActionButtonView(
                        title: "Tu possèdes déjà CashFlow Max ! Merci !".localized // TODO: TBL
                    ) { }
                } else {
                    VStack(spacing: .small) {
                        HStack(spacing: .small) {
                            Text("À vie") // TODO: TBL
                                .font(.Body.small, color: .Base.black)
                            
                            promotionCapsuleView
                            
                            Spacer()
                            
                            Text((lifetime.price*2).toCurrency())
                                .font(.Body.small, color: .Secondary.secondary400)
                                .strikethrough()
                            
                            Text(lifetime.displayPrice)
                                .font(.Body.small, color: .Base.black)
                        }
                        .padding(.standard)
                        .roundedBackground(.classic)
                        
                        ActionButtonView(
                            title: "generic_continue".localized // TODO: TBL
                        ) {
                            await purchasesManager.buyProduct(lifetime)
                        }
                    }
                    
                    Text("Payez une fois et profitez pour toujours") // TODO: TBL
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
        Text("Promotion -50 %") // TODO: TBL
            .font(.Label.large, color: .Red.red500)
            .padding(.horizontal, .small)
            .padding(.vertical, 4)
            .background(Color.Red.red100, in: Capsule())
    }
    
}

// MARK: - Preview
#Preview {
    PaywallPaymentButtonView()
}
