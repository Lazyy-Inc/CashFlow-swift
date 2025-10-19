//
//  IconSVG.swift
//  CashFlow
//
//  Created by Theo Sementa on 08/05/2025.
//

import SwiftUI

public enum IconSVGValue: CGFloat {
    /// Value `10`
    case extraSmall = 10
    /// Value `14`
    case small = 14
    /// Value `16`
    case standard = 16
    /// Value `20`
    case medium = 20
    /// Value `24`
    case large = 24
    /// Value `32`
    case extraLarge = 32
}

public struct IconSVG: View {
    
    // MARK: Dependencies
    var icon: String
    var value: IconSVGValue
    
    // MARK: Init
    public init(icon: String, value: IconSVGValue) {
        self.icon = icon
        self.value = value
    }
    
    // MARK: - View
    public var body: some View {
        Image(icon)
            .resizable()
            .renderingMode(.template)
            .frame(width: value.rawValue, height: value.rawValue)
    }
}

// MARK: - Preview
#Preview {
    IconSVG(icon: "iconWallet", value: .standard)
}
