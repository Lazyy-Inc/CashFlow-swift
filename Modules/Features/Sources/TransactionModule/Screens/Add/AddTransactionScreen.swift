//
//  AddTransactionScreen.swift
//  TurboBudget
//
//  Created by Théo Sementa on 16/06/2023.
//

import SwiftUI
import NetworkKit
import Navigation
import DesignSystem
import Core
import Events
import Models
import Stores

//public struct AddTransactionScreen: View {
//    
//    // MARK: Dependencies
//    var transaction: TransactionModel?
//    
//    // MARK: Environments
//    @Environment(\.dismiss) private var dismiss
//    @EnvironmentObject private var purchasesManager: PurchasesManager
//    
//    // MARK: States
//    @State private var viewModel: ViewModel
//        
//    // Enum
//    enum Field: CaseIterable {
//        case amount, title
//    }
//    @FocusState var focusedField: Field?
//    
//    // MARK: Init
//    public init(transaction: TransactionModel? = nil) {
//        self.transaction = transaction
//        self._viewModel = State(wrappedValue: ViewModel(transaction: transaction))
//    }
//    
//    // MARK: - View
//    public var body: some View {
//        BetterScrollView(maxBlurRadius: Blur.topbar) {
//            NavigationBar(
//                title: viewModel.navigationTitle,
//                dismissAction: { viewModel.dismissAction(dismiss: dismiss) }
//            )
//        } content: { _ in
//            VStack(spacing: 24) {
//                CustomTextField(
//                    text: $viewModel.transactionTitle,
//                    config: .init(
//                        title: Word.Classic.name,
//                        placeholder: viewModel.namePlaceholder.localized
//                    )
//                )
//                .focused($focusedField, equals: .title)
//                .submitLabel(.next)
//                .onSubmit { focusedField = .amount }
//                
//                CustomTextField(
//                    text: $viewModel.transactionAmount,
//                    config: .init(
//                        title: Word.Classic.price,
//                        placeholder: viewModel.amountPlaceholder,
//                        style: .amount
//                    )
//                )
//                .focused($focusedField, equals: .amount)
//                
//                VStack(spacing: 6) {
//                    SelectCategoryButton(
//                        selectedCategory: $viewModel.selectedCategory,
//                        selectedSubcategory: $viewModel.selectedSubcategory
//                    )
//                    
//                    if purchasesManager.isCashFlowPro && viewModel.selectedCategory == nil {
//                        RecommendedCategoryButton(
//                            transactionName: viewModel.transactionTitle,
//                            selectedCategory: $viewModel.selectedCategory,
//                            selectedSubcategory: $viewModel.selectedSubcategory
//                        )
//                    }
//                }
//                .animation(.smooth, value: viewModel.transactionTitle)
//                
//                HStack(spacing: Spacing.small) {
//                    CustomDatePicker(
//                        title: Word.Classic.date,
//                        date: $viewModel.transactionDate,
//                        isFullWidth: purchasesManager.isCashFlowPro
//                    )
//                  
//                    if purchasesManager.isCashFlowPro {
//                        GenericPickerView(
//                            title: "repartition_picker_title".localized,
//                            selectedItem: $viewModel.repartitionType,
//                            items: RepartitionType.allCases,
//                            alignment: .center
//                        )
//                    }
//                }
//                
//                if let selectedAccount = viewModel.accountStore.selectedAccount,
//                   let amountAfterTransaction = viewModel.amountAfterTransaction {
//                    AmountAfterView(
//                        title: "create_transaction_amount_after_transaction".localized,
//                        leftText: selectedAccount.name,
//                        leftValue: amountAfterTransaction
//                    )
//                }
//            }
//            .padding(.horizontal, Spacing.large)
//        }
//        .toolbar { ToolbarDismissKeyboardButtonView() }
//        .scrollDismissesKeyboard(.interactively)
//        .overlay(alignment: .bottom) {
//            ActionButtonView(
//                style: viewModel.isModelValid ? .plain : .disabled,
//                title: viewModel.actionButtonTitle.localized
//            ) {
//                await viewModel.validationAction(dismiss: dismiss)
//            }
//            .padding(Spacing.large)
//        }
//        .ignoresSafeArea(.keyboard)
//        .alertLeaveForm(isPresented: $viewModel.isAlertLeavePresented)
//        .background(Color.Background.bg50.ignoresSafeArea(.all))
//        .navigationBarBackButtonHidden(true)
//    }    
//}


public struct AddTransactionScreen: View {
    
    // MARK: Dependencies
    var transaction: TransactionModel?
    
    // MARK: Environments
    @Environment(\.safeAreaInsets) private var safeAreaInsets
    @Environment(\.dismiss) private var dismiss
    
    // MARK: States
    @State private var viewModel: ViewModel
    @StateObject private var keyboardManager: KeyboardManager = .init()
    @State private var router: Router<AppDestination> = .init()
    @State private var routerManager: AppRouterManager = .shared
    
    // MARK: Init
    public init(transaction: TransactionModel? = nil) {
        self.transaction = transaction
        self._viewModel = State(wrappedValue: ViewModel(transaction: transaction))
    }
    
    // MARK: - View
    public var body: some View {
        NavigationStackView(
            router: router,
            routerManager: routerManager,
            flow: AppFlow.addTransaction,
            isTabPage: false
        ) {
            VStack(spacing: .standard) {
                DismissButtonView()
                    .fullWidth(.trailing)
                
                VStack(spacing: .zero) {
                    TextFieldView(
                        text: $viewModel.transactionTitle,
                        title: "Nom de la transaction", // TODO: TBL
                        placeholder: viewModel.namePlaceholder.localized
                    )
                    
                    VStack(spacing: .tiny) {
                        amountView
                        categorySelectionButtonView
                    }
                    .fullSize()
                    
                    VStack(spacing: .medium) {
                        HStack(spacing: .medium) {
                            DatePickerView(date: $viewModel.transactionDate)
                            repartitionPickerView
                        }
                        
                        if keyboardManager.isKeyboardVisible {
                            Color.clear.frame(height: keyboardManager.keyboardHeight - safeAreaInsets.bottom - .standard)
                        } else {
                            NumericKeyboardView(
                                value: $viewModel.transactionAmount,
                                validationAction: { await viewModel.validationAction(dismiss: dismiss) }
                            )
                        }
                    }
                }
            }
            .padding(.horizontal, .large)
            .padding(.vertical, .standard)
            .background(Color.Background.bg50)
            .alertLeaveForm(isPresented: $viewModel.isAlertLeavePresented)
            .animation(.smooth, value: keyboardManager.isKeyboardVisible)
            .lockView()
        }
    }
}

// MARK: - Subviews
private extension AddTransactionScreen {
    
    var amountView: some View {
        HStack(spacing: .tiny) {
            Text(UserCurrency.symbol)
                .font(.Display.small, color: .Text.tertiary)
            Text(viewModel.transactionAmount)
                .contentTransition(.numericText())
                .font(.Display.extraLarge)
        }
        .animation(.smooth, value: viewModel.transactionAmount)
        .fullWidth()
        .overlay(alignment: .trailing) {
            DeleteNumberButtonView(amount: $viewModel.transactionAmount)
                .isDisplayed(viewModel.transactionAmount != "0")
        }
    }
    
    @ViewBuilder
    var categorySelectionButtonView: some View {
        let color: Color? = viewModel.selectedCategory?.color
        let icon = viewModel.selectedSubcategory?.icon ?? viewModel.selectedCategory?.icon ?? "iconTag"
        let text = viewModel.selectedSubcategory?.name ?? viewModel.selectedCategory?.name ?? "Catégorie" // TODO: TBL
        
        SmallActionButtonView(
            style: color == nil ? .noValue : .withValue(bgColor: color!),
            icon: ImageType(rawValue: icon) ?? .iconTag,
            text: text
        ) {
            router.present(route: .sheet(style: .large), .category(.select(
                selectedCategory: $viewModel.selectedCategory,
                selectedSubcategory: $viewModel.selectedSubcategory
            )))
        }
    }
    
    var repartitionPickerView: some View { // TODO: Make a component
        Menu {
            ForEach(RepartitionType.allCases, id: \.self) { item in
                Button { viewModel.repartitionType = item } label: {
                    Text(item.name.localized)
                }
            }
        } label: {
            SmallActionButtonView(
                style: viewModel.repartitionType != .notDefined ? .withValue(bgColor: viewModel.repartitionType.color) : .noValue,
                icon: .iconBarChart,
                text: viewModel.repartitionType.name.localized
            )
        }
    }
    
}

// MARK: - Preview
#Preview {
    AddTransactionScreen()
}

extension View { // TODO: move
    
    /// Only used for VStack
    func lockView() -> some View {
        GeometryReader { geometry in
            self
                .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .ignoresSafeArea(.keyboard)
    }
    
}
