//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 05/01/2026.
//

import Foundation
import SwiftUI

public enum RoundedBackgroundType {
    case classic
    case field
    case row
    case custom(color: Color, radius: CGFloat, lineWidth: CGFloat = 1, strokeColor: Color? = nil)
}
