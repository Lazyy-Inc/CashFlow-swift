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
    
    // MARK: - View
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
                    contentView(for: transaction)
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
    func contentView(for transaction: TransactionModel) -> some View {
        VStack(spacing: .large) {
            if transaction.type == .transfer {
                amountView(for: transaction)
                dividerView
                dateRowView(for: transaction)
                dividerView
                transferInformationView(for: transaction)
            } else {
                amountView(for: transaction)
                if viewModel.bestCategory != nil {
                    dividerView
                    recommendedRowView(for: transaction)
                }
                dividerView
                dateRowView(for: transaction)
                dividerView
                categoriesView(for: transaction)
                dividerView
                repartitionView(for: transaction)
                if transaction.lat != nil && transaction.long != nil {
                    dividerView
                    TransactionMapRow(transaction: transaction)
                }
            }
        }
    }
    
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
                IconView(asset: .iconEllipsis, size: .small, color: .Text.primary)
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
            if transaction.isFromSubscription {
                Text("transaction_detail_linked_to_subscription".localized) // TODO: TBL
                    .font(.Body.medium, color: .Text.secondary)
            }
            if transaction.isFromApplePay {
                Text("transaction_detail_linked_to_applepay".localized) // TODO: TBL
                    .font(.Body.medium, color: .Text.secondary)
            }
        }
    }
    
    @ViewBuilder
    func dateRowView(for transaction: TransactionModel) -> some View {
        let fullDate = transaction.date.formatted(.dateTime.weekday(.wide).day(.defaultDigits).month(.abbreviated).year())
        let time = ", \(transaction.date.formatted(.dateTime.hour().minute()))"
        
        DetailRowView(
            icon: .iconCalendar,
            text: "generic_date".localized,
            value: fullDate + (transaction.isFromApplePay ? time : "")
        )
        // TODO: Add change date on tap
    }
    
    @ViewBuilder
    func categoriesView(for transaction: TransactionModel) -> some View {
        let accentColor = transaction.categoryColor
        
        Button {
            presentChangeCategory(transactionId: transaction.id)
        } label: {
            VStack(spacing: .medium) {
                if let category = transaction.category {
                    DetailRowView(
                        icon: ImageType(rawValue: category.icon) ?? .iconAlert,
                        iconColor: accentColor,
                        value: category.name
                    )
                }
                
                if let subcategory = transaction.subcategory {
                    DetailRowView(
                        icon: ImageType(rawValue: subcategory.icon) ?? .iconAlert,
                        iconColor: accentColor,
                        value: subcategory.name
                    )
                }
            }
        }
    }
    
    @ViewBuilder
    func repartitionView(for transaction: TransactionModel) -> some View {
        DetailRowView(
            icon: .iconCalendar,
            text: "generic_repartion".localized,
            value: viewModel.currentReparitionType.name.localized,
            valueColor: viewModel.currentReparitionType.color
        )
        .overlay {
            Menu {
                Picker("", selection: $viewModel.currentReparitionType) {
                    ForEach(RepartitionType.allCases, id: \.self) { item in
                        Text(item.name.localized).tag(item)
                    }
                }
            } label: {
                Color.clear
            }
        }
        .onChange(of: viewModel.currentReparitionType) { _, newValue in
            viewModel.updateRepartion(newValue)
        }
    }
    
    @ViewBuilder
    func transferInformationView(for transaction: TransactionModel) -> some View {
        VStack(spacing: .medium) {
            if let senderAccount = transaction.senderAccount {
                DetailRowView(
                    icon: .iconSend,
                    text: Word.Classic.senderAccount,
                    value: senderAccount.name
                )
            }
            
            if let receiverAccount = transaction.receiverAccount {
                DetailRowView(
                    icon: .iconInbox,
                    text: Word.Classic.receiverAccount,
                    value: receiverAccount.name
                )
            }
        }
    }
    
    @ViewBuilder
    func recommendedRowView(for transaction: TransactionModel) -> some View {
        if let categoryFound = viewModel.bestCategory {
            let subcategoryFound = viewModel.bestSubcategory
            let categoryIcon = subcategoryFound?.icon ?? categoryFound.icon
            
            Button {
                viewModel.selectedCategory = categoryFound
                if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
                viewModel.updateCategory(transactionID: transaction.id)
            } label: {
                VStack(spacing: .medium) {
                    HStack(spacing: .small) {
                        IconView(asset: .iconSparkles, color: .Text.primary)
                        Text("generic_recommended".localized) // TODO: TBL
                            .font(.Body.medium)
                    }
                    
                    HStack(spacing: .small) {
                        IconView(asset: ImageType(rawValue: categoryIcon) ?? .iconAlert, color: .Base.white)
                        Text(subcategoryFound?.name ?? categoryFound.name)
                            .font(.Body.medium, color: .Base.white)
                    }
                    .padding(.horizontal, .standard)
                    .padding(.vertical, .medium)
                    .background(categoryFound.color, in: .rect(cornerRadius: .medium, style: .continuous))
                }
            }
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
