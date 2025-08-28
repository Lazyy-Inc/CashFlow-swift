//
//  HomeScreenSavingsPlanView.swift
//  CashFlow
//
//  Created by Theo Sementa on 21/07/2023.
//
// Localizations 01/10/2023
// Refactor 25/02/2024

import SwiftUI
import Navigation
import PreferenceModule
import CoreModule
import DesignSystemModule
import Dependencies
import SavingsPlanModule

struct HomeScreenSavingsPlanView: View {
        
    // Environment
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    @Dependency(\.contributionStore) private var contributionStore
    
    // Preferences
    @StateObject var preferencesDisplayHome: PreferencesDisplayHome = .shared

    // Other
    private let layout: [GridItem] = [
        GridItem(.flexible(minimum: 40), spacing: 20),
        GridItem(.flexible(minimum: 40), spacing: 20)
    ]
    
    // MARK: - body
    var body: some View {
        VStack {
            HomeScreenComponentHeaderView(type: .savingsPlan)
            
            if !savingsPlanStore.savingsPlans.isEmpty {
                LazyVGrid(columns: layout, alignment: .center) {
                    ForEach(savingsPlanStore.savingsPlans.prefix(preferencesDisplayHome.savingsPlan_value)) { savingsPlan in
                        NavigationButtonView(
                            route: .push,
                            destination: AppDestination.savingsPlan(.detail(savingsPlan: savingsPlan)),
                            onNavigate: {
                                Task {
                                    if let savingsPlanID = savingsPlan.id {
                                        await contributionStore.fetchContributions(savingsplanID: savingsPlanID)
                                    }
                                }
                            },
                            label: {
                                SavingsPlanRowView(savingsPlan: savingsPlan)
                            }
                        )
                        .padding(.bottom)
                    }
                }
            } else {
                CustomEmptyView(
                    type: .empty(.savingsPlan(.home)),
                    isDisplayed: true
                )
            }
        }
        .animation(.smooth, value: savingsPlanStore.savingsPlans.count)
        .isDisplayed(preferencesDisplayHome.savingsPlan_isDisplayed)
    } // End body
} // End struct

// MARK: - Preview
#Preview {
    HomeScreenSavingsPlanView()
}
