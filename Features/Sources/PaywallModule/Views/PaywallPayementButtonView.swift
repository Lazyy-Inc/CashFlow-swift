//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 01/09/2025.
//

import SwiftUI
import Core
import DesignSystem
import ConfettiSwiftUI

struct PaywallPayementButtonView: View {
  
  // MARK: Environment
  @EnvironmentObject private var purchasesManager: PurchasesManager
  
  @State private var confettiCounter: Int = 0
  
  // MARK: -
  var body: some View {
    AsyncButton {
      if purchasesManager.isCashFlowPro {
        confettiCounter += 1
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
    .confettiCannon(
        counter: $confettiCounter,
        num: 50,
        openingAngle: Angle(degrees: 0),
        closingAngle: Angle(degrees: 360),
        radius: 200
    )
  }
}

// MARK: - Preview
#Preview {
  PaywallPayementButtonView()
}
