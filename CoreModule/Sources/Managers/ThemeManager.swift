//
//  File.swift
//  CoreModule
//
//  Created by Theo Sementa on 09/08/2025.
//

import SwiftUI

public final class ThemeManager: ObservableObject {
    public static let shared = ThemeManager()
    
    @AppStorage("theme") public var theme: ThemeColor = .green
}


public enum ThemeColor: String, CaseIterable {
    case green, blue, purple, red
    
    public var name: String {
        switch self {
        case .green: return "theme_green".localized
        case .blue: return "theme_blue".localized
        case .purple: return "theme_purple".localized
        case .red: return "theme_red".localized
        }
    }
    
    public var nameNotLocalized: String {
        switch self {
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .red: return "Red"
        }
    }
}
