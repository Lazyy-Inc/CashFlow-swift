//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import Foundation
import SwiftUI

public extension View {
    
    @ViewBuilder
    func overlay<T: View>(_ alignment: Alignment = .center, condition: Bool, content: @escaping () -> T) -> some View {
        if condition {
            self.overlay(alignment: alignment, content: content)
        } else {
            self
        }
    }
    
    @ViewBuilder
    func emptyState<T: View>(condition: Bool, content: @escaping () -> T) -> some View {
        if condition {
            content()
        } else {
            self
        }
    }
    
}
