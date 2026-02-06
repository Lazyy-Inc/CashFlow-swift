//
//  SubscriptionDetailsScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 22/12/2024.
//

import SwiftUI
import AlertKit
import Navigation
import DesignSystem
import Core
import Events
import Dependencies
import TransactionModule
import Models

public struct SubscriptionDetailsScreen: View {
    
    // MARK: Dependencies
    var subscriptionId: Int
    @Dependency(\.subscriptionStore) private var subscriptionStore
    
    // MARK: States
    @StateObject var viewModel: ViewModel = .init()
    
    // MARK: Environement
    @Environment(\.dismiss) private var dismiss
    @Environment(Router<AppDestination>.self) private var router
    
    var subscription: SubscriptionModel? {
        return subscriptionStore.subscriptions.first { $0.id == subscriptionId }
    }
    
    // MARK: Init
    public init(subscriptionId: Int) {
        self.subscriptionId = subscriptionId
    }
    
    // MARK: -
    public var body: some View {
        if let subscription {
            VStack(spacing: Spacing.extraLarge) {
                navigationBarView(subscription)
                
                ScrollView(.vertical) {
                    VStack(spacing: Spacing.extraLarge) {
                        amountWithNameView(subscription)
                        
                        VStack(spacing: 24) {
                            frequencySectionView(subscription)
                            categoriesSectionView(subscription)
                            firstSubscriptionSectionView(subscription)
                        }
                        
                        transactionsListView(subscription)
                    }
                    .padding(.horizontal, Padding.large)
                }
                .scrollIndicators(.hidden)
            }
            .navigationBarBackButtonHidden(true)
            .background(Color.Background.bg50)
            .onAppear {
                // EventService.sendEvent(key: EventKeys.subscriptionDetailPage)
            }
        }
    }
}

// MARK: - Subviews
extension SubscriptionDetailsScreen {
    
    @ViewBuilder
    private func navigationBarView(_ subscription: SubscriptionModel) -> some View {
        NavigationBarWithMenu {
            Button {
                router.push(.subscription(.update(subscription: subscription)))
            } label: {
                Label(Word.Classic.edit, systemImage: "pencil")
            }
            
            Button(
                role: .destructive,
                action: { AlertManager.shared.deleteSubscription(subscription: subscription, dismissAction: dismiss) },
                label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
            )
        }
    }
    
    @ViewBuilder
    private func amountWithNameView(_ subscription: SubscriptionModel) -> some View {
        VStack(spacing: Spacing.extraSmall) {
            Text("\(subscription.symbol) \(subscription.amount.toCurrency())")
                .font(.Display.huge, color: subscription.color)
            
            Text(subscription.name)
                .font(.Display.small)
                .multilineTextAlignment(.center)
                .lineLimit(2)
        }
    }
    
    @ViewBuilder
    private func frequencySectionView(_ subscription: SubscriptionModel) -> some View {
        VStack(spacing: 12) {
            DetailRow(
                icon: "iconClockRepeat",
                text: Word.Classic.frequency,
                value: subscription.frequency.name.localized
            )
            
            DetailRow(
                icon: "iconCalendar",
                text: "subscription_detail_next_transaction".localized,
                value: subscription.frequencyDate.formatted(date: .complete, time: .omitted).capitalized
            )
        }
    }
    
    @ViewBuilder
    private func categoriesSectionView(_ subscription: SubscriptionModel) -> some View {
        if let category = subscription.category {
            VStack(spacing: 12) {
                DetailRow(
                    icon: category.icon,
                    value: category.name,
                    iconBackgroundColor: category.color,
                    isCategory: true
                ) {
                    presentChangeCategory()
                }
                
                if let subcategory = subscription.subcategory {
                    DetailRow(
                        icon: subcategory.icon,
                        value: subcategory.name,
                        iconBackgroundColor: subcategory.color,
                        isCategory: true
                    ) {
                        presentChangeCategory()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func firstSubscriptionSectionView(_ subscription: SubscriptionModel) -> some View {
        if let firstSubscriptionDate = subscription.firstSubscriptionDate {
            VStack(spacing: 12) {
                DetailRow(
                    icon: "iconCalendar",
                    text: "subscription_first_subscription".localized,
                    value: firstSubscriptionDate.formatted(date: .complete, time: .omitted).capitalized
                )
                
                //                                DetailRow(
                //                                    icon: "dollarsign",
                //                                    text: "Date since".localized,
                //                                    value: firstSubscriptionDate.monthsBetween(.now).formatted()
                //                                )
            }
        }
    }
    
    @ViewBuilder
    private func transactionsListView(_ subscription: SubscriptionModel) -> some View {
        if let transactions = subscription.transactions {
            VStack(spacing: 16) {
                let transactionsAmount = transactions.map(\.amount).reduce(0, +).toCurrency()
                Text("word_transactions".localized + " (\(transactions.count) - \(transactionsAmount))")
                    .font(.Title.medium)
                    .fullWidth(.leading)
                
                VStack(spacing: 0) {
                    ForEach(transactions.sorted(by: { $0.date > $1.date })) { transaction in
                        NavigationButtonView(
                            route: .fullScreenCover,
                            destination: AppDestination.transaction(.detail(transactionId: transaction.id))
                        ) {
                            FinancialItemRowView(financialItem: transaction)
                                .padding(.bottom, Padding.medium)
                        }
                    }
                }
            }
        }
    }
    
}

// MARK: - Utils
extension SubscriptionDetailsScreen {
    
    func presentChangeCategory() {
        router.present(
            route: .sheet(style: .large),
            .category(.select(
                selectedCategory: $viewModel.selectedCategory,
                selectedSubcategory: $viewModel.selectedSubcategory
            ))
        ) {
            if viewModel.selectedCategory != nil {
                viewModel.updateCategory(subscriptionID: subscriptionId)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    SubscriptionDetailsScreen(subscriptionId: 0)
}
