//
//  PieChart+Extensions.swift
//  CustomPieChart
//
//  Created by Theo Sementa on 11/08/2024.
//

import SwiftUI
import Core
import Models

extension PieChart {
    
    static func adjustValues(_ inputValues: [Double]) -> [Double] {
        let total = inputValues.reduce(0, +)
        let minValue = total * 0.06 // 10% du total
        
        let adjustedValues = inputValues.map { max($0, minValue) }
        let newTotal = adjustedValues.reduce(0, +)
        
        // Normaliser les valeurs pour que leur somme soit toujours égale à 100%
        return adjustedValues
            .map { $0 / newTotal * total }
            .filter { !$0.isNaN }
    }
}
