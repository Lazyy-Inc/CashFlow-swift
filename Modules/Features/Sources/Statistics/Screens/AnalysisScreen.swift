//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 03/09/2025.
//

import SwiftUI
import DesignSystem
import Stores
import Navigation
import Core

public struct AnalysisScreen: View {
    
    // MARK: Dependencies
    @Dependency(\.transactionStore) private var transactionStore: TransactionStore
    @Dependency(\.accountStore) var accountStore: AccountStore
    
    // MARK: States
    @State private var viewModel: ViewModel = .init()
    
    // MARK: Environments
    @Environment(Router<AppDestination>.self) private var router
    @EnvironmentObject private var purchasesManager: PurchasesManager
    
    // MARK: Init
    public init() { }
    
    // MARK: - View
    public var body: some View {
        VStack(spacing: 0) {
            if !transactionStore.transactions.isEmpty {
                ScrollView {
                    VStack(spacing: Spacing.large) {
                        MonthPickerView(selectedMonth: $viewModel.selectedDate)
                            .padding(Spacing.standard)
                            .roundedBackground(.classic)
                        
                        repartitionChartView()
                        cashflowChartView                        
                    }
                    .padding(Padding.large)
                }
                .scrollIndicators(.hidden)
                .contentMargins(.bottom, Spacing.tabbar, for: .scrollContent)
            } else {
                CustomEmptyView(type: .noAnalysis, isPlain: true)
            }
        }
        .background(Color.Background.bg50)
        .task(id: viewModel.selectedDate) {
            if let account = accountStore.selectedAccount, let accountID = account._id {
                await transactionStore.fetchTransactionsByPeriod(
                    accountId: accountID,
                    period: .init(
                        startDate: viewModel.selectedDate.startOfMonth ?? .now,
                        endDate: viewModel.selectedDate.endOfMonth ?? .now
                    )
                )
            }
        }
    }
    
    func fetchCashFlow() async {
        if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
            await accountStore.fetchCashFlow(accountID: accountID, year: viewModel.selectedDate.year)
        }
    }
    
}

fileprivate extension AnalysisScreen {
    
    @ViewBuilder
    func repartitionChartView() -> some View {
        if purchasesManager.isCashFlowPro {
            RepartitionStatisticsCellView(
                date: $viewModel.selectedDate,
                slices: viewModel.slices
            )
        } else {
            Image("repartitionStatisticsBg")
                .resizable()
                .scaledToFit()
                .blur(radius: 10)
                .overlay {
                    CustomEmptyView(type: .noRepartitionStats, isPlain: true)
                        .shadow(radius: 10)
                }
                .overlay(alignment: .bottom) {
                    AsyncButton {
                        if let product = purchasesManager.products.first {
                            await purchasesManager.buyProduct(product)
                        }
                    } label: {
                        Text("paywall_start_trial".localized)
                            .font(.Body.large)
                            .foregroundStyle(Color.white)
                            .fullWidth()
                            .padding(Padding.standard)
                            .background {
                                RoundedRectangle(cornerRadius: CornerRadius.standard, style: .continuous)
                                    .fill(LinearGradient.main)
                            }
                    }
                    .padding(Padding.standard)
                }
        }
    }
    
    var cashflowChartView: some View {
        GenericBarChart(
            title: "statistics_cashflow_chart_title".localized,
            selectedDate: $viewModel.selectedDate,
            values: accountStore.cashflow,
            amount: viewModel.amount
        )
        .onChange(of: viewModel.selectedDate) { // TODO: Refacto
            Task {
                if viewModel.selectedDate.year != viewModel.selectedYear {
                    viewModel.selectedYear = viewModel.selectedDate.year
                    await fetchCashFlow()
                }
                viewModel.amount = accountStore.cashFlowAmount(for: viewModel.selectedDate)
            }
        }
        .task {
            await fetchCashFlow()
            viewModel.amount = accountStore.cashFlowAmount(for: viewModel.selectedDate)
        }
    }
}

// MARK: - Preview
#Preview {
    AnalysisScreen()
}
