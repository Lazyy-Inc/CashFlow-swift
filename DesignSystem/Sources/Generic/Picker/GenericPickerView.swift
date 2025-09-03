//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 02/09/2025.
//

import SwiftUI
import Core
import Models
import TheoKit

public struct GenericPickerView<T: Nameable>: View {
  
  // MARK: Dependencies
  let title: String
  @Binding var selectedItem: T
  let items: [T]
  
  @EnvironmentObject private var themeManager: ThemeManager
  
  public init(title: String, selectedItem: Binding<T>, items: [T]) {
    self.title = title
    self._selectedItem = selectedItem
    self.items = items
  }
  
  // MARK: -
  public var body: some View {
    VStack(alignment: .leading, spacing: 6) {
      Text(title)
        .padding(.leading, 8)
        .font(.system(size: 12, weight: .regular))
      
      HStack(spacing: 0) {
        Spacer()
        Picker(selection: $selectedItem) {
          ForEach(items, id: \.self) { item in
            Text(item.name).tag(item)
          }
        } label: {
          Text(selectedItem.name)
        }
        .tint(themeManager.theme.color)
        .padding(8)
      }
      .roundedRectangleBorder(
        TKDesignSystem.Colors.Background.Theme.bg100,
        radius: CornerRadius.medium,
        lineWidth: 1,
        strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
      )
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
  .environmentObject(ThemeManager())
}
