//
//  AddAutomationsView.swift
//  CashFlow
//
//  Created by Theo Sementa on 18/07/2023.
//
// Localizations 30/09/2023

import SwiftUI
import Navigation
import TheoKit
import DesignSystem
import Core
import Events
import Models

public struct AddSubscriptionScreen: View {
    
    // MARK: Dependencies
    var subscription: SubscriptionModel?
    
    // MARK: States
    @State private var viewModel: ViewModel
    
    // MARK: Environment
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var store: PurchasesManager
    
    // Enum
    enum Field: CaseIterable {
        case amount, title
    }
    @FocusState private var focusedField: Field?
    
    // MARK: Init
    public init(subscription: SubscriptionModel? = nil) {
        self.subscription = subscription
        self._viewModel = State(wrappedValue: ViewModel(subscription: subscription))
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
                        title: Word.Classic.name,
                        placeholder: viewModel.namePlaceholder.localized
                    )
                )
                .focused($focusedField, equals: .title)
                .submitLabel(.next)
                .onSubmit { focusedField = .amount }
                
                CustomTextField(
                    text: $viewModel.amount,
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
                    
                    if store.isCashFlowPro && viewModel.selectedCategory == nil {
                        RecommendedCategoryButton(
                            transactionName: viewModel.name,
                            selectedCategory: $viewModel.selectedCategory,
                            selectedSubcategory: $viewModel.selectedSubcategory
                        )
                    }
                }
                .animation(.smooth, value: viewModel.name)
                
                HStack(spacing: Spacing.small) {
                    CustomDatePicker(
                        title: "create_subscription_field_next_payement_title".localized,
                        date: $viewModel.frequencyDate,
                        onlyFutureDates: true,
                        isFullWidth: true
                    )
                    
                    GenericPickerView(
                        title: Word.Classic.frequency,
                        selectedItem: $viewModel.frequency,
                        items: SubscriptionFrequency.allCases,
                        alignment: .center
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
        .background(Color.Background.bg50)
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Preview
#Preview {
    AddSubscriptionScreen()
}
