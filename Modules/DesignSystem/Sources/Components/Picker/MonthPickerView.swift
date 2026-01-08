//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 31/10/2025.
//

import SwiftUI

public struct MonthPickerView: View {
    
    @Binding var selectedMonth: Date
    
    public init(selectedMonth: Binding<Date>) {
        self._selectedMonth = selectedMonth
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.small) {
            buttonView(icon: "iconArrowLeft", action: previousMonth)
            
            Text(selectedMonth.formatted(.dateTime.month(.wide).year()).capitalized)
                .font(.Body.medium)
                .foregroundStyle(Color.label)
                .contentTransition(.numericText())
                .fullWidth()
                .animation(.smooth, value: selectedMonth)
            
            buttonView(icon: "iconArrowRight", action: nextMonth)
        }
    }
}

extension MonthPickerView {
    
    @ViewBuilder
    private func buttonView(
        icon: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            IconSVG(icon: icon, value: .large)
                .foregroundStyle(Color.label)
                .padding(Spacing.small)
                .roundedRectangleBorder(
                    Color.Background.bg200,
                    radius: CornerRadius.medium
                )
        }
    }
    
}

extension MonthPickerView {
    
    private func previousMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: -1, to: selectedMonth) ?? selectedMonth
    }
    
    private func nextMonth() {
        selectedMonth = Calendar.current.date(byAdding: .month, value: 1, to: selectedMonth) ?? selectedMonth
    }
    
}

// MARK: - Preview
#Preview {
    MonthPickerView(selectedMonth: .constant(.now))
        .padding()
}
