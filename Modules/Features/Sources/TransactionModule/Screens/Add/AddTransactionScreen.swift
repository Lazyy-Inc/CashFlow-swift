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
import ToastBannerKit

//                    if purchasesManager.isCashFlowPro && viewModel.selectedCategory == nil {
//                        RecommendedCategoryButton(
//                            transactionName: viewModel.transactionTitle,
//                            selectedCategory: $viewModel.selectedCategory,
//                            selectedSubcategory: $viewModel.selectedSubcategory
//                        )
//                    }

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
                DismissButtonView { viewModel.dismissAction(dismiss: dismiss) }
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
                            RepartitionPickerView(repartitionType: $viewModel.repartitionType)
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
            .toastBanner(
                item: $viewModel.toastBannerService.toastBanner,
                config: .init(yOffset: 10, animation: .smooth),
            ) { toastBanner in
                ToastBannerView(banner: toastBanner)
            }
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
            viewModel.onTapSelectCategory()
        }
        .clipped()
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
