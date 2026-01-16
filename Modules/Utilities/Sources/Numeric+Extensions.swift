//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 16/01/2026.
//

import Foundation

public extension Numeric {
    
    func toCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        return formatter.string(for: self) ?? ""
    }
    
}
