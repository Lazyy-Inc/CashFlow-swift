//
//  PieSlice.swift
//  CustomPieChart
//
//  Created by Theo Sementa on 11/08/2024.
//

import Foundation
import SwiftUI

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var cornerRadius: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2

        if cornerRadius <= 0 {
            // Path original sans coins arrondis
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: startAngle - .degrees(90), endAngle: endAngle - .degrees(90), clockwise: false)
            path.closeSubpath()
        } else {
            // Path avec coins arrondis - approche simplifiée
            let adjustedStartAngle = startAngle - .degrees(90)
            let adjustedEndAngle = endAngle - .degrees(90)

            // Créer le path de base
            path.move(to: center)
            path.addArc(center: center, radius: radius, startAngle: adjustedStartAngle, endAngle: adjustedEndAngle, clockwise: false)
            path.closeSubpath()
        }

        return path
    }
}
