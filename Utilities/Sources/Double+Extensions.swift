//
//  File.swift
//  Utilities
//
//  Created by Theo Sementa on 13/11/2025.
//

import Foundation

public extension Double {
    
    func toString(minDigits: Int = 0, maxDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minDigits
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
