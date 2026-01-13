//
//  GenericBarChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Charts
import Core

public struct GenericBarChart: View {
    
    // Builder
    var title: String
    @Binding var selectedDate: Date
    var values: [Double]
    var amount: Double
    var withMonthSelection: Bool
    
    @Environment(\.theme) private var theme
    
    public init(
        title: String,
        selectedDate: Binding<Date>,
        values: [Double],
        amount: Double,
        withMonthSelection: Bool = false
    ) {
        self.title = title
        self._selectedDate = selectedDate
        self.values = values
        self.amount = amount
        self.withMonthSelection = withMonthSelection
    }
    
    // MARK: -
    public var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.Body.small, color: .Text.secondary)
                    
                    Text(amount.toCurrency())
                        .font(.Title.large)
                        .animation(.smooth, value: amount)
                        .contentTransition(.numericText())
                }
                Spacer()
            }
            .padding(8)
            
            Chart {
                ForEach(values.indices, id: \.self) { index in
                    let value = values[index]
                    BarMark(
                        x: .value("x", "\(index)"),
                        y: .value("y", value)
                    )
                    .foregroundStyle(selectedDate.month == (index + 1) ? Color.blue.gradient : theme.color.gradient)
                    .offset(x: 0, y: value > 0 ? -2 : 2)
                    .clipShape(
                        UnevenRoundedRectangle(
                            topLeadingRadius: value > 0 ? 8 : 2,
                            bottomLeadingRadius: value < 0 ? 8 : 2,
                            bottomTrailingRadius: value < 0 ? 8 : 2,
                            topTrailingRadius: value > 0 ? 8 : 2,
                            style: .continuous
                        )
                    )
                }
            }
            .chartYAxis {
                AxisMarks { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.Background.bg200)
                    AxisValueLabel {
                        if let doubleValue = value.as(Double.self) {
                            Text(doubleValue.toCurrency())
                                .font(.system(size: 11, weight: .semibold))
                                .padding(.leading, 4)
                        }
                    }
                }
            }
            .chartXAxis {
                AxisMarks { value in
                    let month = value.index > 11 ? "" : Calendar.current.monthSymbols[value.index]
                    AxisValueLabel {
                        Text(String(month.prefix(3)))
                            .padding(.top, 8)
                    }
                }
            }
            .frame(height: 200)
            
//            MonthPickerView(selectedMonth: $selectedDate)
//                .padding(Spacing.medium)
        }
        .padding(Padding.medium)
        .roundedBackground(.classic)
    }
}

// MARK: - Preview
#Preview {
    GenericBarChart(
        title: "",
        selectedDate: .constant(.now),
        values: [12, 34, 56, 42, 35, 0, 0, 0, 0, 0, 0, 0],
        amount: 340
    )
}
