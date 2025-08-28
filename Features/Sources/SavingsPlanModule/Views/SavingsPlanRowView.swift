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
    @EnvironmentObject private var themeManager: ThemeManager
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    
    var currentSavingsPlan: SavingsPlanModel {
        return savingsPlanStore.savingsPlans.first { $0.id == savingsPlan.id } ?? savingsPlan
    }
    
    public init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
    }

    // MARK: -
    public var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg200)
                    .cornerRadius(CornerRadius.small)
                    .overlay {
                        Text(currentSavingsPlan.emoji ?? "")
                            .font(.system(size: 24, weight: .semibold, design: .rounded))
                    }
                
                Spacer()
                
                Image("iconArrowRight")
                    .renderingMode(.template)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
                        
            VStack(spacing: 0) {
                Text("\((savingsPlan.currentAmount ?? 0).toCurrency())")
                    .fontWithLineHeight(.Title.large)
                    .foregroundStyle(Color.label)
                Text("/ \((savingsPlan.goalAmount ?? 0).toCurrency())")
                    .fontWithLineHeight(.Label.large)
                    .foregroundStyle(TKDesignSystem.Colors.Background.Theme.bg600)
            }
            .frame(maxHeight: .infinity)
                                   
            Text(currentSavingsPlan.name ?? "")
                .fontWithLineHeight(.Body.medium)
                .foregroundStyle(Color.label)
                .lineLimit(1)
        }
        .padding(Padding.standard)
        .aspectRatio(1, contentMode: .fit)
        .roundedRectangleBorder(
            TKDesignSystem.Colors.Background.Theme.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: TKDesignSystem.Colors.Background.Theme.bg200
        )
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanRowView(savingsPlan: .mockClassicSavingsPlan)
        .environmentObject(ThemeManager())
        .environment(SavingsPlanStore.shared)
        .frame(width: 180)
        .padding()
        .background(Color.Background.bg50)
}
