//
//  PaywallRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/12/2024.
//

import SwiftUI
import DesignSystem
import Core

struct PaywallRowView: View {
  
  // MARK: Depedencies
  var imageName: String
  var title: String
  var text: String
  var color: Color
  var isDetailed: Bool
  
  // MARK: - View
  var body: some View {
    HStack(spacing: 12) {
      RoundedRectangle(cornerRadius: CornerRadius.standard, style: .continuous)
        .frame(width: 44, height: 44)
        .foregroundStyle(color.opacity(0.3))
        .overlay {
          Image(imageName)
            .resizable()
            .renderingMode(.template)
            .frame(width: 24, height: 24)
            .foregroundStyle(color)
        }
      
      VStack(alignment: .leading, spacing: 0) {
        Text(title)
          .font(.Body.medium)
          .lineLimit(1)
          .foregroundStyle(Color.text)
        
        Text(text)
          .font(.Body.small)
          .multilineTextAlignment(.leading)
          .lineLimit(3)
          .foregroundStyle(Color.Background.bg600)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      
      if isDetailed {
        Image(systemName: "chevron.right")
          .foregroundStyle(Color.text)
      }
    }
  }
}

// MARK: - Preview
#Preview {
  PaywallRowView(
    imageName: "chart.pie.fill",
    title: "word_budgets".localized,
    text: "paywall_budgets_desc".localized,
    color: .purple,
    isDetailed: true
  )
  .padding(24)
  .background(Color.Background.bg50)
}
