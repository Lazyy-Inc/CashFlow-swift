//
//  CustomDatePickerWithToggle.swift
//  CashFlow
//
//  Created by Theo Sementa on 06/10/2024.
//

import SwiftUI
import DesignSystem
import Core

struct CustomDatePickerWithToggle: View {
    
    // Builder
    var title: String
    @Binding var date: Date
    @Binding var isEnabled: Bool
    var withRange: Bool = false
    
    @State private var isDatePickerShowing: Bool = false
    @State private var datePickerHeight: CGFloat = 0
    
    @Environment(\.theme) private var theme
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            VStack(alignment: .trailing, spacing: 0) {
                HStack {
                    Button {
                        withAnimation { isEnabled.toggle() }
                    } label: {
                        Image("iconCheck")
                            .renderingMode(.template)
                            .foregroundStyle(Color.label)
                            .padding(8)
                            .frame(width: self.datePickerHeight, height: self.datePickerHeight)
                            .roundedRectangleBorder(
                                isEnabled ? theme.color : Color.Background.bg300,
                                radius: 8
                            )
                    }
                    
                    Spacer()
                    
                    Button {
                        if isEnabled {
                            withAnimation { isDatePickerShowing.toggle() }
                        }
                    } label: {
                        Text(date.formatted(Date.FormatStyle().day().month(.abbreviated).year()))
                            .contentTransition(.numericText())
                            .foregroundStyle(Color.label)
                            .font(.Body.medium)
                            .padding(Padding.medium)
                            .roundedBackground(.custom(color: .Background.bg200, radius: .small))
                    }
                    .opacity(isEnabled ? 1 : 0.6)
                    .getSize { size in
                        self.datePickerHeight = size.height
                    }
                    
                }
                .padding(Padding.extraSmall)
                
                if isDatePickerShowing {
                    if withRange {
                        DatePicker("", selection: $date, in: Date()..., displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(theme.color)
                    } else {
                        DatePicker("", selection: $date, displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                            .tint(theme.color)
                    }
                }
            }
            .fullWidth(.trailing)
            .roundedBackground(.field)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .onChange(of: isEnabled) { _, newValue in
            if newValue == false {
                withAnimation { self.isDatePickerShowing = false }
            }
        }
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    CustomDatePickerWithToggle(
        title: "Preview title",
        date: .constant(.now),
        isEnabled: .constant(true)
    )
    .padding()
    .preferredColorScheme(.dark)
}
