//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 19/10/2025.
//

import Foundation
import SwiftUI

public extension View {
    
    func overlay<T: View>(
        _ alignment: Alignment = .center,
        condition: Bool,
        @ViewBuilder content: () -> T
    ) -> some View {
        self.overlay(alignment: alignment) {
            if condition { content() }
        }
    }
    
    func emptyState<T: View>(
        condition: Bool,
        @ViewBuilder content: @escaping () -> T
    ) -> some View {
        ZStack {
            self
            if condition {
                content()
            }
        }
    }
    
    func onLoadOrChange<T: Equatable>(
        of value: T,
        perform action: @escaping (_ newValue: T) async -> Void
    ) -> some View {
        self
            .onViewDidLoad {
                await action(value)
            }
            .onChangeAsync(of: value) { newValue in
                await action(newValue)
            }
    }

}
