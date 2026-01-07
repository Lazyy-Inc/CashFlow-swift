//
//  AddTransferScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import DesignSystem
import Core
import Events
import Models

public struct AddTransferScreen: View {
    
    // MARK: Dependencies
    @State private var viewModel: ViewModel
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    @Environment(\.theme) private var theme
    
    // MARK: Init
    public init(receiverAccount: AccountModel? = nil) {
        self._viewModel = State(wrappedValue: .init(receiverAccount: receiverAccount))
    }
    
    // MARK: - View
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: Word.Title.Transfer.new,
                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
            )
        } content: { _ in
            VStack(spacing: 24) {
                CustomTextField(
                    text: $viewModel.amount,
                    config: .init(
                        title: Word.Classic.amount,
                        placeholder: viewModel.amountPlaceholder,
                        style: .amount
                    )
                )
                
                CustomDatePicker(
                    title: Word.Classic.date,
                    date: $viewModel.date
                )
                
                AccountPicker(
                    title: Word.Classic.senderAccount,
                    selected: $viewModel.senderAccount
                )
                
                AccountPicker(
                    title: Word.Classic.receiverAccount,
                    selected: $viewModel.receiverAccount
                )
                
                let amount = viewModel.amount.toDouble()
                if let senderAccount = viewModel.senderAccount,
                   let receiverAccount = viewModel.receiverAccount,
                   !viewModel.amount.isBlank {
                    AmountAfterView(
                        title: "create_transfer_amount_after_transfer".localized,
                        leftText: senderAccount.name,
                        leftValue: (senderAccount.balance - amount).toCurrency(),
                        rightText: receiverAccount.name,
                        rightValue: (receiverAccount.balance + amount).toCurrency()
                    )
                }
                
            }
            .padding(.horizontal, Spacing.large)
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
    AddTransferScreen()
}
