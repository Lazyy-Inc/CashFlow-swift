//
//  GenericLineChart.swift
//  CashFlow
//
//  Created by Theo Sementa on 30/12/2024.
//

import SwiftUI
import Charts
import Core
import Models

public struct GenericLineChartView: View {
    
    // builder
    var selectedDate: Date
    var values: [AmountByDay]
    var config: Configuration
    
    // Computed
    var amounts: [Double] {
        return values.map(\.amount)
    }
    
    public init(
        selectedDate: Date,
        values: [AmountByDay],
        config: Configuration
    ) {
        self.selectedDate = selectedDate
        self.values = values
        self.config = config
    }
    
    // MARK: -
    public var body: some View {
        VStack(spacing: Spacing.large) {
            VStack(alignment: .leading, spacing: Spacing.extraSmall) {
                Text(config.title)
                    .foregroundStyle(Color.Background.bg600)
                    .font(.Body.small)
                
                Text(amounts.reduce(0, +).toCurrency())
                    .foregroundStyle(Color.label)
                    .font(.Title.medium)
            }
            .fullWidth(.leading)
            
            Chart {
                ForEach(values) { item in
                    LineMark(x: .value("Day", item.day),
                             y: .value("Value", item.amount))
                    .interpolationMethod(.catmullRom)
                    .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
                    .foregroundStyle(config.mainColor)
                    
                    AreaMark(x: .value("Day", item.day),
                             y: .value("Value", item.amount))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [config.mainColor.opacity(0.6), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
            }
            .frame(height: 180)
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
                AxisMarks { _ in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1))
                        .foregroundStyle(Color.Background.bg200)
                    AxisValueLabel()
                        .font(.system(size: 11, weight: .semibold))
                        .offset(y: 4)
                }
            }
        }
        .padding(Padding.standard)
        .roundedBackground(.classic)
    } // body
} // struct

// MARK: - Configuration
extension GenericLineChartView {
    public struct Configuration {
        var title: String
        var mainColor: Color
        
        public init(
            title: String,
            mainColor: Color
        ) {
            self.title = title
            self.mainColor = mainColor
        }
    }
}

// MARK: - Preview
#Preview {
    GenericLineChartView(
        selectedDate: .now,
        values: [.mockToday, .mockTomorrow],
        config: .init(
            title: "Preview chart",
            mainColor: Color.Error.error400
        )
    )
}
