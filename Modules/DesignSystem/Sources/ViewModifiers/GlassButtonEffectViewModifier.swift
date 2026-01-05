//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 10/09/2025.
//

import Foundation
import SwiftUI

struct GlassButtonEffectViewModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .apply {
                if #available(iOS 26, *) {
                    $0
                        .padding(Padding.small)
                        .glassEffect()
                } else {
                    $0
                }
            }
    }
}

public extension View {
    func glassButtonEffect() -> some View {
        modifier(GlassButtonEffectViewModifier())
    }
}
