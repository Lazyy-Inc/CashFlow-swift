//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 23/10/2025.
//

import SwiftUI
import Models

public struct PickerDetailRowView<T: Nameable>: View {
    
    // MARK: Dependencies
    var icon: String
    var text: String?
    @Binding var selectedItem: T
    let items: [T]
    var iconBackgroundColor: Color = Color.Background.bg200
    
    @Environment(\.theme) private var theme
    
    // MARK: Init
    public init(
        icon: String,
        text: String? = nil,
        selectedItem: Binding<T>,
        items: [T],
        iconBackgroundColor: Color = Color.Background.bg200,
    ) {
        self.icon = icon
        self.text = text
        self._selectedItem = selectedItem
        self.items = items
        self.iconBackgroundColor = iconBackgroundColor
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: 8) {
            IconSVG(icon: icon, value: .small)
                .foregroundStyle(Color.Text.primary)
                .padding(6)
                .background {
                    Circle().fill(iconBackgroundColor)
                }
            
            if let text {
                Text(text)
                    .font(.Body.small, color: .Text.primary)
                    .lineLimit(1)
                    .fixedSize(horizontal: true, vertical: true)
            }
            
            Menu {
                Picker("", selection: $selectedItem) {
                    ForEach(items, id: \.self) { item in
                        Text(item.name.localized).tag(item)
                    }
                }
            } label: {
                HStack(spacing: Spacing.extraSmall) {
                    Text(selectedItem.name.localized)
                        .lineLimit(1)
                    
                    IconSVG(icon: "iconChevronUpDown", value: .medium)
                }
                .font(.Body.medium, color: theme.color)
                .fullWidth(.trailing)
            }
            .labelsHidden()
        }
        .padding()
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    }
}

// MARK: - Preview
#Preview {
    PickerDetailRowView(
        icon: "iconCart",
        selectedItem: .constant(RepartitionType.saved),
        items: RepartitionType.allCases
    )
}
