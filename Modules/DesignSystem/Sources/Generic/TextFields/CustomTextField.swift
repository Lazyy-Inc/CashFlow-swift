//
//  CustomTextField.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import Core

public enum CustomTextFieldStyle {
    case text
    case amount
}

public struct CustomTextField: View {
    
    // Builder
    @Binding var text: String
    var config: Configuration
        
    public init(text: Binding<String>, config: Configuration) {
        self._text = text
        self.config = config
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: Spacing.extraSmall) {
            Text(config.title)
                .padding(.leading, Spacing.small)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: .zero) {
                TextField(config.placeholder, text: $text)
                    .keyboardType(config.style == .amount ? .decimalPad : .default)
                    .font(.Body.medium)
                    .padding([.vertical, .leading], Padding.regular)
                    .padding(.trailing, config.style == .amount ? .small : Padding.regular)
                
                if config.style == .amount {
                    Text(UserCurrency.symbol)
                        .padding(.vertical, Padding.regular)
                        .padding(.trailing)
                }
            }
            .roundedBackground(.field)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .focusOnTap()
    }
}

public extension CustomTextField {
    struct Configuration {
        public var title: String
        public var placeholder: String
        public var style: CustomTextFieldStyle = .text
        
        public init(
            title: String,
            placeholder: String,
            style: CustomTextFieldStyle = .text
        ) {
            self.title = title
            self.placeholder = placeholder
            self.style = style
        }
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: 16) {
        CustomTextField(
            text: .constant(""),
            config: .init(
                title: "Preview title",
                placeholder: "Preview placeholder",
                style: .text
            )
        )
        CustomTextField(
            text: .constant(""),
            config: .init(
                title: "Preview title",
                placeholder: "Preview placeholder",
                style: .amount
            )
        )
    }
    .padding()
    .background(Color.black.opacity(0.2))
}
