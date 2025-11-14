//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 20/07/2025.
//

import Foundation
import SwiftUI

extension Binding where Value == String {
    public func max(_ limit: Int) -> Self {
        if self.wrappedValue.count > limit {
            DispatchQueue.main.async {
                self.wrappedValue = String(self.wrappedValue.dropLast())
            }
        }
        return self
    }
}

extension Binding: @retroactive Equatable where Value: Equatable {
    public static func == (lhs: Binding<Value>, rhs: Binding<Value>) -> Bool {
        lhs.wrappedValue == rhs.wrappedValue
    }
}
extension Binding: @retroactive Hashable where Value: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.wrappedValue.hashValue)
    }
}
