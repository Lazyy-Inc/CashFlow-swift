//
//  AddTransactionScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI
import NetworkKit
import Navigation
import TheoKit
import DesignSystem
import Core
import Events
import Models
import Stores
import Dependencies

public struct AddTransactionScreen: View {
    
    // MARK: Dependencies
    var transaction: TransactionModel?
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var purchasesManager: PurchasesManager
    
    // MARK: States
    @State private var viewModel: ViewModel
        
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState var focusedField: Field?
    
    // MARK: Init
    public init(transaction: TransactionModel? = nil) {
        self.transaction = transaction
        self._viewModel = State(wrappedValue: ViewModel(transaction: transaction))
    }
    
    // MARK: - View
    public var body: some View {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
            NavigationBar(
                title: viewModel.navigationTitle,
                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
            )
        } content: { _ in
            VStack(spacing: 24) {
                CustomTextField(
                    text: $viewModel.transactionTitle,
                    config: .init(
                        title: Word.Classic.name,
                        placeholder: viewModel.namePlaceholder.localized
                    )
                )
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit { focusedField = .amount }
                
                CustomTextField(
                    text: $viewModel.transactionAmount,
                    config: .init(
                        title: Word.Classic.price,
                        placeholder: viewModel.amountPlaceholder,
                        style: .amount
                    )
                )
                .focused($focusedField, equals: .amount)
                
                VStack(spacing: 6) {
                    SelectCategoryButton(
                        selectedCategory: $viewModel.selectedCategory,
                        selectedSubcategory: $viewModel.selectedSubcategory
                    )
                    
                    if purchasesManager.isCashFlowPro && viewModel.selectedCategory == nil {
                        RecommendedCategoryButton(
                            transactionName: viewModel.transactionTitle,
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                    }
                }
                .animation(.smooth, value: viewModel.transactionTitle)
                
                HStack(spacing: Spacing.small) {
                    CustomDatePicker(
                        title: Word.Classic.date,
                        date: $viewModel.transactionDate,
                        isFullWidth: purchasesManager.isCashFlowPro
                    )
                  
                    if purchasesManager.isCashFlowPro {
                        GenericPickerView(
                            title: "repartition_picker_title".localized,
                            selectedItem: $viewModel.repartitionType,
                            items: RepartitionType.allCases,
                            alignment: .center
                        )
                    }
                }
                
                if let selectedAccount = viewModel.accountStore.selectedAccount,
                   let amountAfterTransaction = viewModel.amountAfterTransaction {
                    AmountAfterView(
                        title: "create_transaction_amount_after_transaction".localized,
                        leftText: selectedAccount.name,
                        leftValue: amountAfterTransaction
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
    AddTransactionScreen()
}
