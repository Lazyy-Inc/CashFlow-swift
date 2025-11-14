//
//  CustomDatePicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import TheoKit
import Core

public struct CustomDatePicker: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    var onlyFutureDates: Bool = false
    var isFullWidth: Bool = false
    
    let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()
    
    @Environment(\.theme) private var theme
    
    public init(
        title: String,
        date: Binding<Date>,
        onlyFutureDates: Bool = false,
        isFullWidth: Bool = false
    ) {
        self.title = title
        self._date = date
        self.onlyFutureDates = onlyFutureDates
        self.isFullWidth = isFullWidth
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            VStack(alignment: .trailing, spacing: 0) {
                Text(date.formatted(.dateTime.day().month(.abbreviated).year()))
                    .contentTransition(.numericText())
                    .foregroundStyle(Color.label)
                    .fontWithLineHeight(.Body.medium)
                    .padding(Padding.medium)
                    .frame(maxWidth: isFullWidth ? .infinity : nil, alignment: .center)
                    .roundedRectangleBorder(
                        TKDesignSystem.Colors.Background.Theme.bg200,
                        radius: CornerRadius.small
                    )
                    .padding(Padding.extraSmall)
                    .animation(.smooth, value: date)
            }
            .fullWidth(.trailing)
            .roundedRectangleBorder(
                TKDesignSystem.Colors.Background.Theme.bg100,
                radius: CornerRadius.medium,
                lineWidth: 1,
                strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
            )
            .overlay {
                HStack(spacing: 0) {
                    ForEach(0..<3) { _ in
                        if onlyFutureDates {
                            DatePicker("", selection: $date, in: tomorrow..., displayedComponents: [.date])
                        } else {
                            DatePicker("", selection: $date, displayedComponents: [.date])
                        }
                    }
                    .tint(theme.color)
                    .labelsHidden()
                    .colorMultiply(Color.clear)
                }
            }
        }
        .fullWidth(.leading)
        .onAppear {
            if onlyFutureDates {
                date = tomorrow
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomDatePicker(
        title: "Preview title",
        date: .constant(.now)
    )
    .padding()
}
