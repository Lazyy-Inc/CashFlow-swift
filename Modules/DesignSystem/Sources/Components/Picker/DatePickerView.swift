//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI

public struct DatePickerView: View {
    
    // MARK: Dependencies
    @Binding var date: Date
    
    // MARK: States
    @State private var showCalendar: Bool = false
    
    // MARK: Init
    public init(date: Binding<Date>) {
        self._date = date
    }
    
    // MARK: - View
    public var body: some View {
        SmallActionButtonView(
            icon: .iconCalendar,
            text: date.formatted(.dateTime.day().month(.abbreviated).year()),
            config: .init(isFullWidth: true)
        ) {
            showCalendar.toggle()
        }
        .popover(isPresented: $showCalendar) {
            DatePicker(
                "Select date",
                selection: $date,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding()
            .frame(width: 365, height: 365) // Support iPhone SE
            .presentationCompactAdaptation(.popover) // show popOver on iPhones
        }
        .onChange(of: date) {
            showCalendar = false
        }
    }
}

// MARK: - Preview
#Preview {
    @Previewable @State var date: Date = .now
    DatePickerView(date: $date)
}
