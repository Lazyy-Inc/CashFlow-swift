//
//  AddsCardsView.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//
// Localizations -> 30/09/2023
// Refactor -> 17/02/2024

import SwiftUI
import Core
import DesignSystem
import NetworkKit
import Models
import Stores

public struct AddAccountScreen: View {
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: Init
    public init(type: AccountType, account: AccountModel? = nil) {
        self._viewModel = State(wrappedValue: .init(type: type, account: account))
    }
    
    // MARK: -
    public var body: some View {        
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: viewModel.navigationTitle,
                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
            )
        } content: { _ in
            VStack(spacing: 24) {
                CustomTextField(
                    text: $viewModel.name,
                    config: .init(
                        title: "create_account_field_name_title".localized,
                        placeholder: viewModel.accountPlaceholder.localized
                    )
                )
                
                if viewModel.account == nil {
                    CustomTextField(
                        text: $viewModel.balance,
                        config: .init(
                            title: "create_account_field_current_amount_title".localized,
                            placeholder: viewModel.balancePlaceholder,
                            style: .amount
                        )
                    )
                }
                
                if viewModel.type == .savings {
                    CustomTextField(
                        text: $viewModel.maxAmount,
                        config: .init(
                            title: Word.Classic.maxAmount,
                            placeholder: viewModel.maxAmountPlaceholder,
                            style: .amount
                        )
                    )
                }
            }
            .padding(.horizontal, Spacing.large)
        }
        .scrollDismissesKeyboard(.interactively)
        .toolbar { ToolbarDismissKeyboardButtonView() }
        .overlay(alignment: .bottom) {
            ActionButtonView(
                style: viewModel.isModelValid ? .plain : .disabled,
                title: viewModel.actionButtonTitle.localized
            ) {
                await viewModel.validationAction(dismiss: dismiss)
            }
            .padding(Spacing.large)
        }
        .alertLeaveForm(isPresented: $viewModel.isAlertLeavePresented)
        .background(Color.Background.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    AddAccountScreen(type: .classic)
}
