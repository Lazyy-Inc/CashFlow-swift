//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 01/09/2025.
//

import SwiftUI
import Core
import DesignSystem

struct PaywallPayementButtonView: View {
  
  // MARK: Environment
  @EnvironmentObject private var purchasesManager: PurchasesManager
  
  // MARK: -
  var body: some View {
    AsyncButton {
      if purchasesManager.isCashFlowPro {
        // TODO: Send confetti
      } else {
        if let product = purchasesManager.products.first {
          await purchasesManager.buyProduct(product)
        }
      }
    } label: {
      Text(purchasesManager.isCashFlowPro ? "paywall_thanks".localized : "paywall_start_trial".localized)
        .fontWithLineHeight(.Body.large)
        .foregroundStyle(Color.white)
        .fullWidth()
        .padding(Padding.standard)
        .background {
          RoundedRectangle(cornerRadius: CornerRadius.standard, style: .continuous)
            .fill(LinearGradient.main)
        }
    }
  }  
}

// MARK: - Preview
#Preview {
  PaywallPayementButtonView()
}
