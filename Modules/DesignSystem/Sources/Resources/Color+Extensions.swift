//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 23/07/2025.
//

import Foundation
import SwiftUI

public extension Color {
    
    struct Base {
        public static var white: Color {
            return Color("baseWhite", bundle: .module)
        }
        public static var black: Color {
            return Color("baseBlack", bundle: .module)
        }
    }
    
    static var primary500: Color {
        return Color("Primary500", bundle: BundleHelper.bundle)
    }
    
    struct Secondary {
        public static var secondary300: Color {
            return Color("Secondary300", bundle: BundleHelper.bundle)
        }
        
        public static var secondary400: Color {
            return Color("Secondary400", bundle: BundleHelper.bundle)
        }
    }
    
}

public extension Color {
    
    struct Background {
        public static var bg50: Color {
            return Color("background50", bundle: BundleHelper.bundle)
        }
        
        public static var bg100: Color {
            return Color("background100", bundle: BundleHelper.bundle)
        }
        
        public static var bg200: Color {
            return Color("background200", bundle: BundleHelper.bundle)
        }
        
        public static var bg300: Color {
            return Color("background300", bundle: BundleHelper.bundle)
        }
        
        public static var bg400: Color {
            return Color("background400", bundle: BundleHelper.bundle)
        }
        
        public static var bg500: Color {
            return Color("background500", bundle: BundleHelper.bundle)
        }
        
        public static var bg600: Color {
            return Color("background600", bundle: BundleHelper.bundle)
        }
    }
    
    struct Settings {
        public static var settingsBlue: Color {
            return Color("settingsBlue", bundle: .module)
        }
        public static var settingsDarkBlue: Color {
            return Color("settingsDarkBlue", bundle: .module)
        }
        public static var settingsDarkPurple: Color {
            return Color("settingsDarkPurple", bundle: .module)
        }
        public static var settingsGray: Color {
            return Color("settingsGray", bundle: .module)
        }
        public static var settingsGreen: Color {
            return Color("settingsGreen", bundle: .module)
        }
        public static var settingsOrange: Color {
            return Color("settingsOrange", bundle: .module)
        }
        public static var settingsPurple: Color {
            return Color("settingsPurple", bundle: .module)
        }
        public static var settingsRed: Color {
            return Color("settingsRed", bundle: .module)
        }
        public static var settingsTurquoise: Color {
            return Color("settingsTurquoise", bundle: .module)
        }
    }
    
    struct Red {
        public static var red500: Color {
            return Color("red500", bundle: .module)
        }
    }
    
    struct Error {
        public static var error400: Color {
            return Color("Error400", bundle: BundleHelper.bundle)
        }
        public static var error600: Color {
            return Color("Error600", bundle: BundleHelper.bundle)
        }
    }
    
    struct Category {
        public static var categoryLeisure: Color {
            return Color("categoryLeisure", bundle: BundleHelper.bundle)
        }
        
        public static var categorySavings: Color {
            return Color("categorySavings", bundle: BundleHelper.bundle)
        }
        
        public static var categoryHealth: Color {
            return Color("categoryHealth", bundle: BundleHelper.bundle)
        }
    }
    
}

public extension Color {
    
    static var text: Color {
        return Color("text", bundle: BundleHelper.bundle)
    }
    
    static var textReversed: Color {
        return Color("textReversed", bundle: BundleHelper.bundle)
    }
    
    static var customGray: Color {
        return Color("customGray", bundle: BundleHelper.bundle)
    }
    
}
