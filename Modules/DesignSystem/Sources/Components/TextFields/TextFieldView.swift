//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 21/01/2026.
//

import SwiftUI

public struct TextFieldView: View {
    
    // MARK: Dependencies
    @Binding var text: String
    let title: String
    let placeholder: String
    
    // MARK: States
    @FocusState private var isFocused: Bool
    
    // MARK: Init
    public init(
        text: Binding<String>,
        title: String,
        placeholder: String
    ) {
        self._text = text
        self.title = title
        self.placeholder = placeholder
    }
    
    // MARK: - View
    public var body: some View {
        VStack(spacing: .tiny) {
            Text(title)
                .font(.Label.large)
            TextField("", text: $text)
                .font(.Title.medium, color: .Text.primary)
                .focused($isFocused)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .overlay(condition: text.isEmpty) {
                    Text(placeholder)
                        .font(.Title.medium, color: .Text.secondary)
                }
                .submitLabel(.done)
        }
        .onTapGesture { isFocused.toggle() }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var text: String = ""
    TextFieldView(text: $text, title: "The title of the field", placeholder: "Hello World!")
}
