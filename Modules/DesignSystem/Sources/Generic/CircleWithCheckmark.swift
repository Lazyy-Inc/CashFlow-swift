//
//  CircleWithCheckmark.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/08/2023.
//

import SwiftUI
import Core

public struct CircleWithCheckmark: View {

    // State or Binding Int, Float and Double
    @State private var scaleCheckmark: CGFloat = 0
    
    @Environment(\.theme) private var theme
    
    public init() { }
    
    // MARK: - Body
    public var body: some View {
        Circle()
            .frame(width: 100, height: 100)
            .foregroundStyle(theme.color)
            .overlay {
                Image(systemName: "checkmark")
                    .foregroundStyle(Color.white)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .scaleEffect(scaleCheckmark)
            }
            .onAppear {
                withAnimation(.interpolatingSpring(stiffness: 170, damping: 5).delay(0.3)) { scaleCheckmark = 1.2 }
            }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CircleWithCheckmark()
}
