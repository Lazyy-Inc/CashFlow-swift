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
import TheoKit
import DesignSystem
import NetworkKit
import Models
import Stores
import Dependencies

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
        .overlay(alignment: .bottom) {
            ActionButtonView(
                style: viewModel.isAccountValid() ? .plain : .disabled,
                title: viewModel.actionButtonTitle
            ) {
                await viewModel.accountAction(dismiss: dismiss)
            }
            .padding(Spacing.large)
        }
        .scrollDismissesKeyboard(.interactively)
        .alert(
            "confirmation_leave_form_title".localized,
            isPresented: $viewModel.presentingConfirmationDialog,
            actions: {
                Button("confirmation_leave_form_destructive_button".localized, role: .destructive, action: { dismiss() })
                Button("confirmation_leave_form_cancel_button".localized, role: .cancel, action: {})
            },
            message: {
                Text("confirmation_leave_form_message".localized)
            }
        )
        .background(Color.Background.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    AddAccountScreen(type: .classic)
}
