//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 23/07/2025.
//

import Foundation
import SwiftUI

extension Color {
    
    static func dynamicColor(light: UInt, dark: UInt) -> Color {
        let lightColor = Color(hex: light)
        let darkColor = Color(hex: dark)
        
        return Color(
            uiColor: UIColor { $0.userInterfaceStyle == .dark ? UIColor(darkColor) : UIColor(lightColor) }
        )
    }
    
    init(hex: UInt, alpha: Double = 1.0) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: alpha
        )
    }
    
}

public extension Color {
    
    struct Base {
        public static let white: Color = Color(hex: 0xFFFFFF)
        public static let black: Color = Color(hex: 0x000000)
    }
    
    struct Text {
        public static let primary: Color = dynamicColor(light: 0x000000, dark: 0xFFFFFF)
        public static let primaryReversed: Color = dynamicColor(light: 0xFFFFFF, dark: 0x000000)
        public static let secondary: Color = dynamicColor(light: 0x7F7F7F, dark: 0xACB5BB)
        public static let tertiary: Color = dynamicColor(light: 0xACB5BB, dark: 0x7F7F7F)
    }
    
    struct Background {
        public static let bg50: Color = dynamicColor(light: 0xF2F2F7, dark: 0x101010)
        public static let bg100: Color = dynamicColor(light: 0xFFFFFF, dark: 0x1C1C1E)
        public static let bg200: Color = dynamicColor(light: 0xE5E5EA, dark: 0x2C2C2E)
        public static let bg300: Color = dynamicColor(light: 0xD1D1D6, dark: 0x3A3A3C)
        public static let bg400: Color = dynamicColor(light: 0xC7C7CC, dark: 0x48484A)
        public static let bg500: Color = dynamicColor(light: 0xA9A9AB, dark: 0x636366)
        public static let bg600: Color = dynamicColor(light: 0x8E8E93, dark: 0x8E8E93)
    }
    
    struct Secondary {
        public static var secondary300: Color {
            return Color("Secondary300", bundle: .module)
        }
        
        public static var secondary400: Color {
            return Color("Secondary400", bundle: .module)
        }
    }
    
}

public extension Color {
    
    struct Primary {
        public static let p500: Color = Color(hex: 0x34B67F)
    }
    
    struct Red {
        public static let r50: Color = Color(hex: 0xFFF5F4)
        public static let r100: Color = Color(hex: 0xFFCFCD)
        public static let r200: Color = Color(hex: 0xFFAAA5)
        public static let r300: Color = Color(hex: 0xFF857E)
        public static let r400: Color = Color(hex: 0xFF6057)
        public static let r500: Color = Color(hex: 0xFF3B30)
        public static let r600: Color = Color(hex: 0xCC2F26)
        public static let r700: Color = Color(hex: 0x99231C)
        public static let r800: Color = Color(hex: 0x661713)
        public static let r900: Color = Color(hex: 0x320B09)
    }
    
    struct Settings {
        public static let blue: Color = Color(hex: 0x0277BD)
        public static let darkBlue: Color = Color(hex: 0x283593)
        public static let darkPurple: Color = Color(hex: 0x512DA8)
        public static let gray: Color = Color(hex: 0x8E8E93)
        public static let green: Color = Color(hex: 0x2E7D32)
        public static let orange: Color = Color(hex: 0xEF6C00)
        public static let purple: Color = Color(hex: 0x8E24AA)
        public static let red: Color = Color(hex: 0xC62828)
        public static let turquoise: Color = Color(hex: 0x00796B)
    }
    
}

public extension Color {
    
    struct Error {
        public static var error400: Color {
            return Color("Error400", bundle: .module)
        }
        public static var error600: Color {
            return Color("Error600", bundle: .module)
        }
    }
    
    struct Category {
        public static var categoryLeisure: Color {
            return Color("categoryLeisure", bundle: .module)
        }
        
        public static var categorySavings: Color {
            return Color("categorySavings", bundle: .module)
        }
        
        public static var categoryHealth: Color {
            return Color("categoryHealth", bundle: .module)
        }
    }
    
}

public extension Color {
    
    static var customGray: Color {
        return Color("customGray", bundle: .module)
    }
    
}
