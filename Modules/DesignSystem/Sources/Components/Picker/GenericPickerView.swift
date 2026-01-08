//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 02/09/2025.
//

import SwiftUI
import Core
import Models

public struct GenericPickerView<T: Nameable>: View {
    
    // MARK: Dependencies
    let title: String
    @Binding var selectedItem: T
    let items: [T]
    var alignment: Alignment
    
    @Environment(\.theme) private var theme
    
    public init(
        title: String,
        selectedItem: Binding<T>,
        items: [T],
        alignment: Alignment = .trailing
    ) {
        self.title = title
        self._selectedItem = selectedItem
        self.items = items
        self.alignment = alignment
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            Picker(selection: $selectedItem) {
                ForEach(items, id: \.self) { item in
                    Text(item.name.localized).tag(item)
                }
            } label: {
                Text(selectedItem.name)
            }
            .tint(theme.color)
            .fullWidth(alignment)
            .padding(.small)
            .roundedBackground(.field)
        }
    }
}

// MARK: - Preview
#Preview {
    GenericPickerView(
        title: "repartition_picker_title".localized,
        selectedItem: .constant(RepartitionType.saved),
        items: RepartitionType.allCases
    )
}
