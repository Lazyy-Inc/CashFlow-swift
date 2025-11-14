//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 05/09/2025.
//

import SwiftUI
import Models
import Core
import DesignSystem

struct RepartitionProgressView: View {
  
  // MARK: Dependencies
  let title: String
  let value: Double
  let maxValue: Double
  let color: Color
  
  // MARK: -
  var body: some View {
    VStack(spacing: Spacing.extraSmall) {
      HStack {
        Text(title)
          .fontWithLineHeight(.Body.small)
          .fullWidth(.leading)
        
        Text("\(value.toCurrency()) / \(maxValue.toCurrency())")
          .fontWithLineHeight(.Body.mediumBold)
      }
      
      RoundedRectangle(cornerRadius: CornerRadius.extraSmall, style: .continuous)
        .fill(Color.Background.bg200)
        .frame(height: 20)
        .overlay(alignment: .leading) {
          GeometryReader { geo in
            RoundedRectangle(cornerRadius: CornerRadius.extraSmall, style: .continuous)
              .fill(color)
              .frame(width: geo.size.width * CGFloat(min(value / maxValue, 1.0)), height: 20)
          }
        }
        
    }
  }
  
}

// MARK: - Preview
#Preview {
  RepartitionProgressView(
    title: "Besoins", value: 200, maxValue: 300, color: Color.Category.categoryHealth
  )
  .padding()
}
