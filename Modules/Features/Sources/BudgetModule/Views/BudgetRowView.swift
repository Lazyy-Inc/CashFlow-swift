//
//  BudgetRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import TheoKit
import DesignSystem
import Core
import Dependencies
import Models
import Mocks

struct BudgetRowView: View {
    
    // Builder
    var budget: BudgetModel
    
    @Dependency(\.budgetStore) private var budgetStore
    
    var currentBudget: BudgetModel {
        return budgetStore.budgets.first { $0.id == budget.id } ?? budget
    }
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading) {
            Text(currentBudget.name)
                .font(.mediumCustom(size: 20))
            
            HStack(alignment: .center) {
                let value = budget.currentAmount / budget.amount
                ProgressCircle(
                    value: value,
                    percentage: value * 10,
                    color: budget.color
                )
                .frame(width: 90, height: 90)
                .padding(8)
                Spacer()
                VStack(spacing: 10) {
                    HStack {
                        Text("budget_cell_max".localized + " :")
                        Spacer()
                      Text(currentBudget.amount.formattedAbbreviatedCurrency())
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.Background.bg200)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium, style: .continuous))
                  
                    HStack {
                        Text("budget_cell_actual".localized + " :")
                        Spacer()
                      Text(currentBudget.currentAmount.formattedAbbreviatedCurrency())
                    }
                    .lineLimit(1)
                    .padding(8)
                    .background(Color.Background.bg200)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium, style: .continuous))
                  
                    if currentBudget.amount < currentBudget.currentAmount {
                        HStack {
                            Text("budget_cell_overrun".localized + " :")
                            Spacer()
                          Text((currentBudget.currentAmount - currentBudget.amount).formattedAbbreviatedCurrency())
                        }
                        .lineLimit(1)
                        .padding(8)
                        .background(Color.Background.bg200)
                        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium, style: .continuous))
                    }
                }
                .font(.Body.medium)
                .padding(8)
            }
        }
        .foregroundStyle(Color.label)
        .padding()
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
    BudgetRowView(budget: .mock)
}
