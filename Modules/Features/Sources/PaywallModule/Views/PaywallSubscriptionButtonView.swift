//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 01/09/2025.
//

import SwiftUI
import Core
import DesignSystem

enum PaywallSubscriptionType {
  case cashFlowPlus, cashFlowMax
  
  var title: String {
    switch self {
    case .cashFlowPlus:
      return "CashFlow Plus"
    case .cashFlowMax:
      return "CashFlow Max"
    }
  }
  
  func subtitle(price: String) -> String {
    let firstText: String = "paywall_seven_days_free".localized + "\(UserCurrency.symbol)"
    let secondText: String = String(format: "paywall_then_by_month".localized, price)
    return firstText + " - " + secondText
  }
    
}

struct PaywallSubscriptionButtonView: View {
  
  // MARK: Dependencies
  let style: PaywallSubscriptionType
  
  // MARK: Environment
  @EnvironmentObject private var purchasesManager: PurchasesManager
  
  var price: String {
    switch style {
    case .cashFlowPlus:
      return purchasesManager.cashFlowPlus?.displayPrice ?? ""
    case .cashFlowMax:
      return ""
    }
  }
  
  // MARK: -
  var body: some View {
    Button {
      
    } label: {
      VStack(alignment: .leading, spacing: Spacing.extraSmall) {
        Text(style.title)
          .font(.Body.large)
        
        Text(style.subtitle(price: price))
          .font(.Body.small)
      }
      .foregroundStyle(Color.white)
      .fullWidth(.leading)
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
  PaywallSubscriptionButtonView(style: .cashFlowPlus)
}
