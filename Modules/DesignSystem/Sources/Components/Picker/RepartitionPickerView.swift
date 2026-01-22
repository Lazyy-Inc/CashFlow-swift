//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Models

public struct RepartitionPickerView: View {
    
    // MARK: Dependencies
    @Binding var repartitionType: RepartitionType
    
    // MARK: Init
    public init(
        repartitionType: Binding<RepartitionType>
    ) {
        self._repartitionType = repartitionType
    }
    
    // MARK: - View
    public var body: some View {
        Menu {
            ForEach(RepartitionType.allCases, id: \.self) { item in
                Button { repartitionType = item } label: {
                    Text(item.name.localized)
                }
            }
        } label: {
            SmallActionButtonView(
                style: repartitionType != .notDefined ? .withValue(bgColor: repartitionType.color) : .noValue,
                icon: .iconBarChart,
                text: repartitionType.name.localized
            )
        }
    }
}

// MARK: - Preview
#Preview {
    RepartitionPickerView(repartitionType: .constant(.needed))
}
