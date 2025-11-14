//
//  CreateTransactionForSavingsAccountScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import Core
import DesignSystem
import TheoKit
import NetworkKit
import Models
import Mocks

public struct CreateTransactionForSavingsAccountScreen: View {
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    public init(savingsAccount: AccountModel, transaction: TransactionModel? = nil) {
        self._viewModel = StateObject(wrappedValue: .init(savingsAccount: savingsAccount, transaction: transaction))
    }
    
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: viewModel.transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update,
                actionButton: .init(
                    title: viewModel.transaction == nil ? Word.Classic.create : Word.Classic.edit,
                    action: {
                        NetworkService.cancelAllTasks()
                        VibrationManager.vibration()
                        if viewModel.transaction == nil {
                            await viewModel.createTransaction(dismiss: dismiss)
                        } else {
                            await viewModel.updateTransaction(dismiss: dismiss)
                        }
                    },
                    isDisabled: !viewModel.validateTrasaction()
                ),
                dismissAction: {
                    if viewModel.isTransactionInCreation() {
                        viewModel.presentingConfirmationDialog.toggle()
                    } else {
                        dismiss()
                    }
                }
            )
        } content: { _ in
            VStack(spacing: 24) {
                CustomTextField(
                    text: $viewModel.transactionTitle,
                    config: .init(
                        title: Word.Classic.name,
                        placeholder: "category11_subcategory3_name".localized
                    )
                )
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit {
                    focusedField = .amount
                }
                
                CustomTextField(
                    text: $viewModel.transactionAmount,
                    config: .init(
                        title: Word.Classic.price,
                        placeholder: "64,87",
                        style: .amount
                    )
                )
                .focused($focusedField, equals: .amount)
                
                TransactionTypePickerView(selected: .constant(.income))
                
                CustomDatePicker(
                    title: Word.Classic.date,
                    date: $viewModel.transactionDate
                )
            }
            .padding(.horizontal, 24)
        }
        .toolbar {
            ToolbarDismissKeyboardButtonView()
        }
        .confirmationDialog("", isPresented: $viewModel.presentingConfirmationDialog) {
            Button("word_cancel_changes".localized, role: .destructive, action: { dismiss() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    } // body
} // struct

// MARK: - Preview
#Preview {
    CreateTransactionForSavingsAccountScreen(savingsAccount: .mockSavingsAccount)
}
