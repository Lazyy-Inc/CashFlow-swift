//
//  FontWithLineHeight.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/05/2025.
//

import SwiftUI

struct FontWithLineHeightViewModifier: ViewModifier {
    
    // MARK: Dependencies
    let font: ExtendedUIFont
    
    // MARK: Computed properties
    var uiFont: UIFont {
        return UIFont(name: font.name, size: font.size) ?? UIFont.systemFont(ofSize: font.size)
    }

    // MARK: - View
    func body(content: Content) -> some View {
        content
            .font(Font(uiFont))
            .lineSpacing(font.lineHeight - uiFont.lineHeight)
            .padding(.vertical, (font.lineHeight - uiFont.lineHeight) / 2)
    }
}

struct FontViewModifier: ViewModifier {
    
    // MARK: Dependencies
    let font: ExtendedUIFont
    var color: Color?
    
    // MARK: Computed properties
    var uiFont: UIFont {
        return UIFont(name: font.name, size: font.size) ?? UIFont.systemFont(ofSize: font.size)
    }

    // MARK: - View
    func body(content: Content) -> some View {
        content
            .font(Font(uiFont))
            .foregroundStyle(color ?? .label)
            .lineSpacing(font.lineHeight - uiFont.lineHeight)
            .padding(.vertical, (font.lineHeight - uiFont.lineHeight) / 2)
    }
}

// MARK: - View Extension
extension View {
    public func fontWithLineHeight(_ font: ExtendedUIFont) -> some View {
        return modifier(FontWithLineHeightViewModifier(font: font))
    }
    
    public func font(_ font: ExtendedUIFont, color: Color? = nil) -> some View {
        return modifier(FontViewModifier(font: font, color: color))
    }
}
