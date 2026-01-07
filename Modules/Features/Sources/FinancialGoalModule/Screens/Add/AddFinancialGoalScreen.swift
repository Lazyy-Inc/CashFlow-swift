//
//  AddFinancialGoalScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 20/06/2023.
//
// Localizations 30/09/2023

import SwiftUI
import MCEmojiPicker
import DesignSystem
import Core
import Events
import Dependencies
import Models
import Stores

public struct AddFinancialGoalScreen: View {
    
    // builder
    var savingsPlan: SavingsPlanModel?
    @State private var viewModel: ViewModel
    
    // Custom
    @Dependency(\.accountStore) var accountStore: AccountStore
    @Dependency(\.savingsPlanStore) private var savingsPlanStore
    @Dependency(\.contributionStore) private var contributionStore
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // Enum
    enum Field: CaseIterable {
        case title, amountOfStart, amountOfEnd
    }
    @FocusState private var focusedField: Field?
    
    // init
    public init(savingsPlan: SavingsPlanModel? = nil) {
        self.savingsPlan = savingsPlan
        self._viewModel = State(wrappedValue: ViewModel(savingsPlan: savingsPlan))
    }
    
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: viewModel.navigationTitle,
                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
            )
        } content: { _ in
            VStack(spacing: Spacing.large) {
                HStack(alignment: .bottom, spacing: 8) {
                    CustomTextField(
                        text: $viewModel.name,
                        config: .init(
                            title: Word.Classic.name,
                            placeholder: viewModel.namePlaceholder.localized
                        )
                    )
                    .focused($focusedField, equals: .title)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .amountOfStart }
                    
                    Button { viewModel.showEmojiPicker.toggle() } label: {
                        Text(viewModel.emoji)
                            .font(.system(size: 16))
                            .padding()
                            .roundedRectangleBorder(
                                Color.Background.bg100,
                                radius: CornerRadius.medium,
                                lineWidth: 1,
                                strokeColor: Color.Background.bg200
                            )
                    }
                    .emojiPicker(
                        isPresented: $viewModel.showEmojiPicker,
                        selectedEmoji: $viewModel.emoji
                    )
                }
                
                if savingsPlan == nil {
                    CustomTextField(
                        text: $viewModel.savingPlanAmountOfStart,
                        config: .init(
                            title: Word.Classic.initialAmount,
                            placeholder: "0.00",
                            style: .amount
                        )
                    )
                    .focused($focusedField, equals: .amountOfStart)
                    .submitLabel(.next)
                    .onSubmit { focusedField = .amountOfEnd }
                }
                
                CustomTextField(
                    text: $viewModel.goalAmount,
                    config: .init(
                        title: Word.Classic.amountToReach,
                        placeholder: viewModel.goalAmountPlaceholder,
                        style: .amount
                    )
                )
                .focused($focusedField, equals: .amountOfEnd)
                .submitLabel(.done)
                
                CustomDatePickerWithToggle(
                    title: Word.Classic.startTargetDate,
                    date: $viewModel.startDate,
                    isEnabled: .constant(true)
                )
                
                CustomDatePickerWithToggle(
                    title: Word.Classic.finalTargetDate,
                    date: $viewModel.endDate,
                    isEnabled: $viewModel.isEndDate,
                    withRange: true
                )
            }
            .padding(.horizontal, Spacing.large)
        }
        .toolbar { ToolbarDismissKeyboardButtonView() }
        .scrollDismissesKeyboard(.interactively)
        .contentMargins(.bottom, 128, for: .scrollContent)
        .overlay(alignment: .bottom) {
            ActionButtonView(
                style: viewModel.isModelValid ? .plain : .disabled,
                title: viewModel.actionButtonTitle.localized
            ) {
                await viewModel.validationAction(dismiss: dismiss)
            }
            .padding(Spacing.large)
            .blurredBackground()
        }
        .ignoresSafeArea(.keyboard)
        .alertLeaveForm(isPresented: $viewModel.isAlertLeavePresented)
        .background(Color.Background.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    AddFinancialGoalScreen()
}
