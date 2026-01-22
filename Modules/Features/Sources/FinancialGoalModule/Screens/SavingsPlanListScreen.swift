//
//  SavingsPlanListScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Navigation
import DesignSystem
import Core
import Events
import Dependencies
import Models

public struct SavingsPlanListScreen: View {
    
    // Environment
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    @Dependency(\.contributionStore) private var contributionStore
    @Environment(Router<AppDestination>.self) private var router
        
    // String variables
    @State private var searchText: String = ""
        
    // Computed var
    private var searchResults: [SavingsPlanModel] {
        return savingsPlanStore.savingsPlans.search(searchText)
    }
    
    // Other
    private let layout: [GridItem] = [GridItem(.flexible(minimum: 40), spacing: 16), GridItem(.flexible(minimum: 40), spacing: 16)]
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: Word.Main.savingsPlans,
                actionButton: .init(
                    title: Word.Classic.create,
                    action: { router.push(.savingsPlan(.create)) },
                    isDisabled: false
                ),
                placeholder: "word_search".localized,
                searchText: $searchText.animation()
            )
        } content: { _ in
            LazyVGrid(columns: layout, alignment: .center) {
                ForEach(searchResults) { savingsPlan in
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
            .padding(.horizontal, Padding.large)
        }
        .emptyState(condition: savingsPlanStore.savingsPlans.isEmpty || (searchResults.isEmpty && !searchText.isEmpty)) {
            CustomEmptyView(
                type: (searchResults.isEmpty && !searchText.isEmpty) ? .noResults(searchText) : .noFinancialGoals,
                isPlain: true
            )
        }
        .navigationBarBackButtonHidden(true)
        .background(Color.Background.bg50)
        .onAppear {
            // EventService.sendEvent(key: EventKeys.savingsplanListPage)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsPlanListScreen()
}
