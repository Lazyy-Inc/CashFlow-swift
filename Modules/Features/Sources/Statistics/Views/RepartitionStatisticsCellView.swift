//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 03/09/2025.
//

import SwiftUI
import Models
import DesignSystem
import Preferences
import Core

struct RepartitionStatisticsCellView: View {
    
    // MARK: Dependencies
    @Binding var date: Date
    let slices: [PieSliceData]
    
    @StateObject private var statisticsPreferences = StatisticsPreferences.shared
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.extraLarge) {
            if statisticsPreferences.salary == 0 {
                Text("statistics_chart_salary_missing".localized)
                    .font(.Body.medium)
                    .foregroundStyle(Color.Red.r500)
            }
            
            PieChart(
                month: date,
                slices: slices,
                config: .init(
                    backgroundColor: Color.Background.bg100,
                    space: 0.2,
                    hole: 0.75,
                    height: 258
                )
            )
            
            if let repartitionRule = statisticsPreferences.repartitionRule.toRepartitionRule() {
                VStack(alignment: .leading, spacing: 0) {
                    Text(statisticsPreferences.repartitionRule)
                        .font(.Body.large, color: .Text.primary)
                    
                    Text(
                        String(
                            format: "statistics_charts_rules_desc".localized,
                            repartitionRule.rawValue,
                            "\(repartitionRule.neededPercentage)",
                            "\(repartitionRule.wantedPercentage)",
                            "\(repartitionRule.savedPercentage)"
                        )
                    )
                    .font(.Body.small)
                    .foregroundStyle(Color.Background.bg600)
                }
                .fullWidth(.leading)
                
                VStack(spacing: Spacing.standard) {
                    RepartitionProgressView(
                        title: RepartitionType.needed.name.localized,
                        value: slices[safe: 0]?.value ?? 0,
                        maxValue: statisticsPreferences.salary * Double(repartitionRule.neededPercentage) / 100.0,
                        color: Color.Category.categoryHealth
                    )
                    
                    RepartitionProgressView(
                        title: RepartitionType.wanted.name.localized,
                        value: slices[safe: 1]?.value ?? 0,
                        maxValue: statisticsPreferences.salary * Double(repartitionRule.wantedPercentage) / 100.0,
                        color: Color.Category.categoryLeisure
                    )
                    
                    RepartitionProgressView(
                        title: RepartitionType.saved.name.localized,
                        value: slices[safe: 2]?.value ?? 0,
                        maxValue: statisticsPreferences.salary * Double(repartitionRule.savedPercentage) / 100.0,
                        color: Color.Category.categorySavings
                    )
                }
            }
        }
        .padding(Padding.large)
        .roundedBackground(.classic)
    }
    
}

// MARK: - Preview
#Preview {
    RepartitionStatisticsCellView(
        date: .constant(.now),
        slices: []
    )
}
