//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 01/09/2025.
//

import Foundation
import SwiftUI

public extension LinearGradient {
    
    static var main: LinearGradient {
        return LinearGradient(
            colors: [
                .Primary.p500,
                Color(hex: "1A836B")
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
}
