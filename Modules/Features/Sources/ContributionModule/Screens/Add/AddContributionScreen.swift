//
//  AddContributionScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Core
import DesignSystem
import Events
import Models
import TheoKit

public struct AddContributionScreen: View {
    
    // MARK: Dependencies
    var savingsPlan: SavingsPlanModel
    
    // Custom
    @State private var viewModel: ViewModel
    
    // Environment
    @Environment(\.dismiss) private var dismiss
    
    // init
    public init(savingsPlan: SavingsPlanModel) {
        self.savingsPlan = savingsPlan
        self._viewModel = State(wrappedValue: .init(savingsPlan: savingsPlan))
    }
    
    // MARK: - Body
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: viewModel.navigationTitle,
                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
            )
        } content: { _ in
            VStack(spacing: Spacing.large) {
                CustomTextField(
                    text: $viewModel.name,
                    config: .init(
                        title: "contribution_create_name".localized,
                        placeholder: "contribution_create_placeholder_name".localized
                    )
                )
                
                CustomTextField(
                    text: $viewModel.amount.max(9),
                    config: .init(
                        title: Word.Classic.amount,
                        placeholder: "200.00",
                        style: .amount
                    )
                )
                
                ContributionTypePickerView(selected: $viewModel.type)
                
                CustomDatePicker(
                    title: Word.Classic.date,
                    date: $viewModel.date
                )
                
                AmountAfterView(
                    title: "create_contribution_field_amount_after_contribution".localized,
                    leftText: savingsPlan.name ?? "",
                    leftValue: viewModel.valueAfterContribution.toCurrency()
                )
                
            }
            .padding(.horizontal, Spacing.large)
            .padding(.top)
        }
        .toolbar { ToolbarDismissKeyboardButtonView() }
        .scrollDismissesKeyboard(.interactively)
        .overlay(alignment: .bottom) {
            ActionButtonView(
                style: viewModel.isModelValid ? .plain : .disabled,
                title: viewModel.actionButtonTitle.localized
            ) {
                await viewModel.validationAction(dismiss: dismiss)
            }
            .padding(Spacing.large)
        }
        .ignoresSafeArea(.keyboard)
        .alertLeaveForm(isPresented: $viewModel.isAlertLeavePresented)
        .background(Color.Background.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    AddContributionScreen(savingsPlan: .mockClassicSavingsPlan)
}
