//
//  TransactionAddScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI
import NetworkKit
import NavigationKit
import StatsKit
import TheoKit
import DesignSystemModule
import CoreModule
import EventModule

public struct TransactionAddScreen: View {
    
    // MARK: Dependencies
    var transaction: TransactionModel?
    
    @StateObject private var viewModel: ViewModel
    
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    @EnvironmentObject private var accountStore: AccountStore
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    // init
    public init(transaction: TransactionModel? = nil) {
        self.transaction = transaction
        self._viewModel = StateObject(wrappedValue: ViewModel(transaction: transaction))
    }
    
    // MARK: -
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: transaction == nil ? Word.Title.Transaction.new : Word.Title.Transaction.update,
                actionButton: .init(
                    title: transaction == nil ? Word.Classic.create : Word.Classic.edit,
                    action: {
                        NetworkService.cancelAllTasks()
                        VibrationManager.vibration()
                        if transaction == nil {
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
                        dismissAction()
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
                
                VStack(spacing: 6) {
                    SelectCategoryButton(
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    
                    if store.isCashFlowPro && viewModel.selectedCategory == nil {
                        RecommendedCategoryButton(
                            transactionName: viewModel.transactionTitle,
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                    }
                }
                .animation(.smooth, value: viewModel.transactionTitle)
                
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
            Button("word_cancel_changes".localized, role: .destructive, action: { dismissAction() })
            Button("word_return".localized, role: .cancel, action: { })
        }
        .background(TKDesignSystem.Colors.Background.Theme.bg50.ignoresSafeArea(.all))
        .navigationBarBackButtonHidden(true)
    }
    
    func dismissAction() {
        if viewModel.isEditing {
            EventService.sendEvent(key: EventKeys.transactionUpdateCanceled)
        } else {
            EventService.sendEvent(key: EventKeys.transactionCreationCanceled)
        }
        dismiss()
    }
    
}

// MARK: - Preview
#Preview {
    TransactionAddScreen()
}
