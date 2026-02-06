//
//  TransactionDetailsScreen.swift
//  CashFlow
//
//  Created by Théo Sementa on 08/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import Navigation
import DesignSystem
import Core
import Events
import Models
import Stores

public struct TransactionDetailsScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.categoryStore) private var categoryStore
    
    // MARK: Environments
    @Environment(\.dismiss) private var dismiss
    
    // MARK: States
    @State private var router: Router<AppDestination> = .init()
    @State private var routerManager: AppRouterManager = .shared
    @State var viewModel: ViewModel
    
    // MARK: Init
    public init(transactionId: Int) {
        self.viewModel = .init(transactionId: transactionId)
    }
    
    // MARK: -
    public var body: some View {
        if let transaction = viewModel.transaction {
            NavigationStackView(
                router: router,
                routerManager: routerManager,
                flow: AppFlow.detailTransaction,
                isTabPage: false
            ) {
                BetterScrollView(maxBlurRadius: Blur.topbar) {
                    headerView(for: transaction)
                        .padding(.horizontal, .large)
                        .padding(.vertical, .standard)
                } content: { _ in
                    VStack(spacing: .large) {
                        amountView(for: transaction)
                        
                        dividerView
                        
                        dateRowView(for: transaction)
                    }
                    .padding(.large)
                }
                .background(Color.Background.bg50)
                .navigationBarBackButtonHidden(true)
                .toolbarBackground(Color.clear, for: .navigationBar)
                .toolbar(.hidden, for: .navigationBar)
                .onAppear {
                    if transaction.type == .transfer {
                        // EventService.sendEvent(key: EventKeys.transferDetailPage)
                    } else {
                        // EventService.sendEvent(key: EventKeys.transactionDetailPage)
                    }
                }
                .task {
                    await viewModel.fetchRecommendCategory()
                }
            }
        }
    }
    
    //    public var body: some View {
    //        if let currentTransaction = viewModel.transaction {
    //            BetterScrollView(maxBlurRadius: Blur.topbar) {
    //                NavigationBarWithMenu {
    //                    NavigationButtonView(
    //                        route: .fullScreenCover,
    //                        destination: .transaction(.update(transaction: currentTransaction))
    //                    ) {
    //                        Label(Word.Classic.edit, systemImage: "pencil")
    //                    }
    //
    //                    Button(
    //                        role: .destructive,
    //                        action: { AlertManager.shared.deleteTransaction(transaction: currentTransaction, dismissAction: dismiss) },
    //                        label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
    //                    )
    //                }
    //            } content: { _ in
    //                VStack(spacing: Spacing.extraLarge) {
    //                    VStack(spacing: Spacing.small) {
    //                        VStack(spacing: Spacing.extraSmall) {
    //                            Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
    //                                .font(.Display.huge, color: currentTransaction.color)
    //
    //                            Text(currentTransaction.nameDisplayed)
    //                                .font(.Display.small)
    //                                .multilineTextAlignment(.center)
    //                                .lineLimit(2)
    //                        }
    //                        if currentTransaction.isFromSubscription == true {
    //                            Text("transaction_detail_automatically_created".localized)
    //                                .font(.Body.medium)
    //                        }
    //                    }
    //
    //                    if let categoryFound = viewModel.bestCategory {
    //                        let subcategoryFound = viewModel.bestSubcategory
    //                        PredictedCategoryRowView(
    //                            category: categoryFound,
    //                            subcategory: subcategoryFound,
    //                            action: {
    //                                viewModel.selectedCategory = categoryFound
    //                                if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
    //                                viewModel.updateCategory(transactionID: currentTransaction.id)
    //                            }
    //                        )
    //                    }
    //
    //                    VStack(spacing: Spacing.medium) {
    //                        DetailRow(
    //                            icon: "iconCalendar",
    //                            text: "transaction_detail_date".localized,
    //                            value: currentTransaction.date.formatted(
    //                                date: .complete,
    //                                time: currentTransaction.isFromApplePay == true ? .shortened : .omitted
    //                            ).capitalized
    //                        )
    //
    //                        if let category = currentTransaction.category {
    //                            DetailRow(
    //                                icon: category.icon,
    //                                value: category.name,
    //                                iconBackgroundColor: category.color,
    //                                isCategory: true
    //                            ) {
    //                                presentChangeCategory(transactionId: currentTransaction.id)
    //                            }
    //
    //                            if let subcategory = currentTransaction.subcategory {
    //                                DetailRow(
    //                                    icon: subcategory.icon,
    //                                    value: subcategory.name,
    //                                    iconBackgroundColor: subcategory.color,
    //                                    isCategory: true
    //                                ) {
    //                                    presentChangeCategory(transactionId: currentTransaction.id)
    //                                }
    //                            }
    //                        }
    //
    //                        PickerDetailRowView(
    //                            icon: "iconPieChart",
    //                            text: "repartition_picker_title".localized,
    //                            selectedItem: $viewModel.currentReparitionType,
    //                            items: RepartitionType.allCases
    //                        )
    //                        .onChange(of: viewModel.currentReparitionType) { _, newValue in
    //                            viewModel.updateRepartion(newValue)
    //                        }
    //
    //                        if let senderAccount = currentTransaction.senderAccount {
    //                            DetailRow(
    //                                icon: "iconSend",
    //                                text: Word.Classic.senderAccount,
    //                                value: senderAccount.name
    //                            )
    //                        }
    //
    //                        if let receiverAccount = currentTransaction.receiverAccount {
    //                            DetailRow(
    //                                icon: "iconInbox",
    //                                text: Word.Classic.receiverAccount,
    //                                value: receiverAccount.name
    //                            )
    //                        }
    //
    //                        if currentTransaction.lat != nil && currentTransaction.long != nil {
    //                            TransactionMapRow(transaction: currentTransaction)
    //                        }
    //                    }
    //                }
    //                .padding(Padding.large)
    //            } // Content ScrollView
    //            .onAppear {
    //                if currentTransaction.type == .transfer {
    //                    // EventService.sendEvent(key: EventKeys.transferDetailPage)
    //                } else {
    //                    // EventService.sendEvent(key: EventKeys.transactionDetailPage)
    //                }
    //            }
    //            .task {
    //                if store.isCashFlowPro && currentTransaction.category?.id == 0 {
    //                    guard !currentTransaction.nameDisplayed.isBlank else { return }
    //                    let transactionID = currentTransaction.id
    //                    if let response = await transactionStore.fetchRecommendedCategory(
    //                        name: currentTransaction.nameDisplayed,
    //                        transactionId: transactionID
    //                    ) {
    //                        if let cat = response.cat {
    //                            viewModel.bestCategory = categoryStore.findCategoryById(cat)
    //                        }
    //                        if let sub = response.sub {
    //                            viewModel.bestSubcategory = categoryStore.findSubcategoryById(sub)
    //                        }
    //                    }
    //                }
    //            }
    //            .navigationBarBackButtonHidden(true)
    //            .toolbarBackground(Color.clear, for: .navigationBar)
    //            .toolbar(.hidden, for: .navigationBar)
    //            .background(Color.Background.bg50)
    //        }
    //    } // body
} // struct

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}

// MARK: - Subviews
private extension TransactionDetailsScreen {
    
    @ViewBuilder
    func headerView(for transaction: TransactionModel) -> some View {
        HStack(spacing: .standard) {
            DismissButtonView()
            Spacer()
            Menu {
                NavigationButtonView(
                    route: .fullScreenCover,
                    destination: .transaction(.update(transaction: transaction))
                ) {
                    Label(Word.Classic.edit, systemImage: "pencil")
                }
                
                Button(
                    role: .destructive,
                    action: { AlertManager.shared.deleteTransaction(transaction: transaction, dismissAction: dismiss) },
                    label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
                )
            } label: {
                IconView(asset: .iconEllipsis, size: .small, color: .Text.secondary)
                    .padding(6)
                    .background(Color.Background.bg100, in: .circle)
            }
        }
    }
    
    var dividerView: some View {
        Line()
            .stroke(Color.Background.bg300, style: .init(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: [4, 8]))
            .frame(height: 2)
    }
    
    @ViewBuilder
    func amountView(for transaction: TransactionModel) -> some View {
        VStack(spacing: Spacing.small) {
            VStack(spacing: Spacing.extraSmall) {
                Text("\(transaction.symbol) \(transaction.amount.toCurrency())")
                    .font(.Display.huge, color: transaction.color)
                
                Text(transaction.nameDisplayed)
                    .font(.Display.small)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            if transaction.isFromSubscription == true {
                Text("transaction_detail_automatically_created".localized)
                    .font(.Body.medium)
            }
        }
    }
    
    @ViewBuilder
    func dateRowView(for transaction: TransactionModel) -> some View {
        HStack(spacing: .small) {
            HStack(spacing: .small) {
                IconView(asset: .iconCalendar, color: .Text.primary)
                Text("generic_date".localized) // TODO: TBL
                    .font(.Body.medium)
            }
            
            Text(
                transaction.date.formatted(
                    date: .complete,
                    time: transaction.isFromApplePay == true ? .shortened : .omitted
                ).capitalized
            )
            .font(.Body.mediumBold)
            .fullWidth(.trailing)
        }
    }
    
}

// MARK: - Utils
extension TransactionDetailsScreen {
    
    func presentChangeCategory(transactionId: Int) {
        router.present(
            route: .sheet(style: .large),
            .category(.select(
                selectedCategory: $viewModel.selectedCategory,
                selectedSubcategory: $viewModel.selectedSubcategory
            ))
        ) {
            if viewModel.selectedCategory != nil {
                viewModel.updateCategory(transactionID: transactionId)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    NavigationStack {
        TransactionDetailsScreen(transactionId: 1)
    }
    .environmentObject(PurchasesManager())
}
