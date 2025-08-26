//
//  BudgetsListScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/08/2023.
//
// Refactor 26/09/2023
// Localizations 01/10/2023

import SwiftUI
import NavigationKit
import TheoKit
import DesignSystemModule
import CoreModule
import Dependencies

public struct BudgetsListScreen: View {
    
    // Environnement
    @EnvironmentObject private var router: Router<AppDestination>
    @Dependency(\.budgetStore) private var budgetStore
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        ListWithBluredHeader(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: "word_budgets".localized,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.budget(.create)) },
                    isDisabled: false
                )
            )
        } content: {
            ForEach(budgetStore.budgetsByCategory.sorted(by: { $0.key.name < $1.key.name }), id: \.key) { category, budgets in
                VStack(spacing: 16) {
                    CategoryHeaderView(category: category)
                    
                    VStack(spacing: 12) {
                        ForEach(budgets) { budget in
                            BudgetRowView(budget: budget)
                                .onTapGesture {
                                    if let subcategory = budget.subcategory {
                                        router.push(.budget(.transactions(subcategory: subcategory)))
                                    }
                                }
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .background(TKDesignSystem.Colors.Background.Theme.bg50.edgesIgnoringSafeArea(.all))
    } // body
} // struct

// MARK: - Preview
#Preview {
    BudgetsListScreen()
}
