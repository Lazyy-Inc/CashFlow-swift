//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 26/10/2025.
//

import Foundation

public extension Int {
    
    func toString(maxDigits: Int = 2) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = maxDigits
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
