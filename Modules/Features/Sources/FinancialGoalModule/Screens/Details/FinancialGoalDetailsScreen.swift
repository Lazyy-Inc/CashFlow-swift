//
//  FinancialGoalDetailsScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import Navigation
import Core
import DesignSystem
import TransactionModule
import Events
import Dependencies
import Models

public struct FinancialGoalDetailsScreen: View {
    
    // MARK: Dependencies
    var savingsPlan: SavingsPlanModel
    
    // MARK: Environments
    @Environment(\.theme) private var theme
    @Environment(\.dismiss) private var dismiss
    
    // MARK: States
    @State private var viewModel: ViewModel

    // MARK: Init
    public init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
        self._viewModel = State(wrappedValue: .init(financialGoalId: savingsPlan.id ?? 0))
    }
    
    // MARK: -
    public var body: some View {
        if let financialGoal = viewModel.financialGoal {
            ScrollView {
                Circle()
                    .frame(width: 100, height: 100)
                    .foregroundStyle(Color.Background.bg100)
                    .overlay {
                        Circle()
                            .frame(width: 80, height: 80)
                            .foregroundStyle(theme.color)
                            .shadow(color: theme.color, radius: 4, y: 2)
                            .overlay {
                                Text(financialGoal.emoji ?? "")
                                    .font(.system(size: 32, weight: .semibold, design: .rounded))
                                    .shadow(radius: 2, y: 2)
                            }
                    }
                
                Text(financialGoal.name ?? "")
                    .font(.Title.large)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .padding(.bottom)
                
                VStack(spacing: 40) {
                    VStack(spacing: 8) {
                        ProgressBarView(percentage: financialGoal.percentageComplete)
                            .frame(height: 48)
                        
                        amountSectionView(for: financialGoal)
                    }
                    
                    monthlySectionView(for: financialGoal)
                    
                    dateSectionView(for: financialGoal)
                    
                    contributionsSectionView(for: financialGoal)
                        .padding(.bottom)
                }
                
            } // ScrollView
            .padding(.horizontal)
            .scrollIndicators(.hidden)
            .onAppear {
                // EventService.sendEvent(key: EventKeys.savingsplanDetailPage)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarDismissPushButton()
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        NavigationButtonView(
                            route: .push,
                            destination: .savingsPlan(.update(savingsPlan: financialGoal))
                        ) {
                            Label(Word.Classic.edit.localized, systemImage: "pencil")
                        }
                        
                        NavigationButtonView(
                            route: .push,
                            destination: .contribution(.create(savingsPlan: financialGoal))
                        ) {
                            Label("savingsplan_detail_add_contribution".localized, systemImage: "plus")
                        }
                        
                        Button(
                            role: .destructive,
                            action: { AlertManager.shared.deleteSavingsPlan(savingsPlan: financialGoal, dismissAction: dismiss) },
                            label: { Label("word_delete".localized, systemImage: "trash.fill") }
                        )
                    } label: {
                        Image(systemName: "ellipsis")
                            .foregroundStyle(Color.Text.primary)
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                    }
                }
                
                ToolbarDismissKeyboardButtonView()
            }
            .background(Color.Background.bg50.edgesIgnoringSafeArea(.all))
            .task {
                if let savingsPlanId = financialGoal.id {
                    await viewModel.contributionStore.fetchContributions(savingsplanID: savingsPlanId)
                }
            }
        }
    }
}

// MARK: - Subviews
extension FinancialGoalDetailsScreen {
    
    private func amountSectionView(for financialGoal: SavingsPlanModel) -> some View {
        VStack(spacing: 8) {
            DetailRow(
                icon: "iconCoins",
                text: Word.Classic.remaining,
                value: viewModel.remainingAmount.toCurrency()
            )
            DetailRow(
                icon: "iconHandCoins",
                text: Word.Classic.contributed,
                value: viewModel.contributionsAmount.toCurrency()
            )
            DetailRow(
                icon: "iconLandmark",
                text: Word.Classic.finalTarget,
                value: financialGoal.goalAmount?.toCurrency() ?? ""
            )
        }
    }
    
    private func monthlySectionView(for financialGoal: SavingsPlanModel) -> some View {
        VStack(spacing: 8) {
            if viewModel.contributionsAmount != 0 {
                GenericBarChart(
                    title: viewModel.selectedDate.formatted(Date.FormatStyle().month(.wide).year()).capitalized,
                    selectedDate: $viewModel.selectedDate,
                    values: viewModel.contributionsByMonth,
                    amount: viewModel.amountOfSelectedMonth,
                    withMonthSelection: true
                )
                .onChange(of: viewModel.selectedDate) { viewModel.onChangeSelectedDate() }
                .onChange(of: viewModel.contributionStore.contributions.count) { viewModel.onChangeContributionsCount() }
                .onAppear { viewModel.onChartAppear() }
            }
            
            if financialGoal.hasAnEndDate {
                DetailRow(
                    icon: "iconLandmark",
                    text: Word.Classic.monthlyTarget,
                    value: viewModel.monthlyTarget.toCurrency()
                )
                
                if viewModel.monthlyTarget != viewModel.recalculatedMonthlyTarget {
                    DetailRow(
                        icon: "iconCoins",
                        text: "Objectif mensuel recalculé".localized, // TODO: TBL
                        value: viewModel.recalculatedMonthlyTarget.toCurrency()
                    )
                }
            }
            
            DetailRow(
                icon: "iconHandCoins",
                text: Word.Classic.contributedThisMonth,
                value: viewModel.contributionsAmountForCurrentMonth.toCurrency()
            )
        }
    }
    
    private func dateSectionView(for financialGoal: SavingsPlanModel) -> some View {
        VStack(spacing: 8) {
            DetailRow(
                icon: "iconCalendar",
                text: Word.Classic.startDate,
                value: financialGoal.startDate.formatted(date: .abbreviated, time: .omitted)
            )
            
            if let endDate = financialGoal.endDate {
                DetailRow(
                    icon: "iconCalendar",
                    text: Word.Classic.endDate,
                    value: endDate.formatted(date: .abbreviated, time: .omitted)
                )
            }
                
            DetailRow(
                icon: "iconHourGlass",
                text: Word.Classic.daysElapsed,
                value: "\(financialGoal.daysSinceStart)"
            )
            
            if financialGoal.hasAnEndDate {
                DetailRow(
                    icon: "iconClock",
                    text: Word.Classic.daysRemaining,
                    value: "\(financialGoal.daysRemaining)"
                )
            }
        }
    }
    
    private func contributionsSectionView(for financialGoal: SavingsPlanModel) -> some View {
        VStack(spacing: 8) {
            HStack {
                Text("word_contributions".localized)
                    .font(.Title.large)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                NavigationButtonView(
                    route: .push,
                    destination: .contribution(.create(savingsPlan: financialGoal))
                ) {
                    Image(systemName: "plus")
                        .font(.system(size: 22, weight: .medium, design: .rounded))
                        .foregroundStyle(Color.Text.primary)
                }
            }
            
            if viewModel.contributionStore.contributions.isNotEmpty {
                ForEach(viewModel.contributionStore.contributions) { contribution in
                    ContributionRowView(savingsPlan: financialGoal, contribution: contribution)
                }
            } else {
                // TODO: !Reactive and test
//                        CFEmptyView(type: .noContributions)
//                            .padding(.top)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    FinancialGoalDetailsScreen(savingsPlan: .mockClassicSavingsPlan)
}
