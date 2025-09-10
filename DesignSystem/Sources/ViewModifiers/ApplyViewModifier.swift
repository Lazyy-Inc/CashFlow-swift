//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 10/09/2025.
//

import Foundation
import SwiftUI

public extension View {
    func apply<V: View>(@ViewBuilder _ block: (Self) -> V) -> V { block(self) }
}
