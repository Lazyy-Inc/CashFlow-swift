//
//  SearchBarView.swift
//  CashFlow
//
//  Created by Theo Sementa on 09/05/2025.
//

import SwiftUI
import Core

public struct SearchBarView: View {
    
    // MARK: Dependencies
    var placeholder: String
    @Binding var searchText: String
    
    @Environment(\.theme) private var theme
        
    // MARK: init
    public init(_ placeholder: String, searchText: Binding<String>) {
        self.placeholder = placeholder
        self._searchText = searchText
    }
    
    var isSearching: Bool {
        return !searchText.isEmpty
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: 8) {
            Image("iconSearch")
                .resizable()
                .renderingMode(.template)
                .frame(width: 20, height: 20)
                .foregroundStyle(isSearching ? theme.color : Color.Background.bg500)
            
            TextField(placeholder, text: $searchText)
                .font(.Body.medium)
                .foregroundStyle(Color.Text.primary)
                .toolbar { ToolbarDismissKeyboardButtonView() }
            
            if isSearching {
                Button {
                    searchText = ""
                } label: {
                    Image("iconXmarkCircle")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 16, height: 16)
                        .foregroundStyle(Color.Text.primary)
                }
            }
        }
        .padding(Padding.regular)
        .roundedBackground(.field)
        .focusOnTap()
    }
}

// MARK: - Preview
#Preview {
    SearchBarView("kn", searchText: .constant("kn"))
        .padding()
        .background(Color.blue)
}
