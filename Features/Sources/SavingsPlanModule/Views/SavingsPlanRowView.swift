//
//  SavingsPlanRowView.swift
//  CashFlow
//
//  Created by Théo Sementa on 24/06/2023.
//

import SwiftUI
import TheoKit
import DesignSystem
import Core
import Dependencies
import Models
import Stores

public struct SavingsPlanRowView: View {

    // Custom type
    var savingsPlan: SavingsPlanModel

    // Environnement
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    
    var currentSavingsPlan: SavingsPlanModel {
        return savingsPlanStore.savingsPlans.first { $0.id == savingsPlan.id } ?? savingsPlan
    }
    
    public init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
    }

    // MARK: -
    public var body: some View {
        VStack(spacing: Spacing.standard) {
            HStack(spacing: Spacing.small) {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.Background.bg200)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small, style: .continuous))
                    .overlay {
                        Text(currentSavingsPlan.emoji ?? "")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                
                Text(savingsPlan.name ?? "")
                    .fontWithLineHeight(.Body.medium)
                    .foregroundStyle(Color.label)
                    .lineLimit(1)
                    .fullWidth(.leading)
                                
                Image("iconArrowRight")
                    .renderingMode(.template)
                    .foregroundStyle(Color.Background.bg600)
            }
            
            VStack(spacing: Spacing.extraSmall) {
                HStack(spacing: 0) {
                    Text("\((savingsPlan.currentAmount ?? 0).toCurrency())")
                        .fontWithLineHeight(.Body.small)
                        .foregroundStyle(Color.label)
                        .fullWidth(.leading)
                    
                    Text("/ \((savingsPlan.goalAmount ?? 0).toCurrency())")
                        .fontWithLineHeight(.Body.small)
                        .foregroundStyle(Color.Background.bg600)
                        .fullWidth(.trailing)
                }
                
                ProgressBarView(
                    percentage: savingsPlan.percentageComplete,
                    config: .init(
                        backgroundColor: Color.Background.bg200,
                        strokeColor: Color.Background.bg300
                    )
                )
                .frame(height: 40)
            }
        }
        .fullWidth()
        .padding(Padding.standard)
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanRowView(savingsPlan: .mockClassicSavingsPlan)
        .environment(SavingsPlanStore.shared)
        .padding()
        .background(Color.Background.bg50)
}
