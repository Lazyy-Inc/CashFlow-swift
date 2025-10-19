//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 03/09/2025.
//

import SwiftUI
import TheoKit
import DesignSystem
import Stores
import Navigation
import Dependencies
import Core

public struct StatisticsScreen: View {
  
  @State private var viewModel: ViewModel = .init()
  
  @Dependency(\.transactionStore) private var transactionStore: TransactionStore
  @Dependency(\.accountStore) var accountStore: AccountStore
  @EnvironmentObject private var router: Router<AppDestination>
  @EnvironmentObject private var purchasesManager: PurchasesManager
  
  public init() { }
  
  // MARK: -
  public var body: some View {
    VStack(spacing: 0) {
      if !transactionStore.transactions.isEmpty {
        BetterScrollView(maxBlurRadius: Blur.topbar) {
          NavigationBar(
            title: "word_statistics".localized,
            withDismiss: false,
            actionButton: .init(
              icon: "iconGear",
              action: { router.push(.settings(.home)) },
              isDisabled: false
            )
          )
        } content: { _ in
          VStack(spacing: Spacing.large) {
            GenericBarChart(
                title: "cashflowchart_title".localized,
                selectedDate: $viewModel.selectedDate,
                values: accountStore.cashflow,
                amount: viewModel.amount
            )
            .onChange(of: viewModel.selectedDate) {
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
            
            if purchasesManager.isCashFlowPro {
              RepartitionStatisticsCellView(
                date: $viewModel.repartitionDate,
                slices: viewModel.slices
              )
            } else {
              Image("repartitionStatisticsBg")
                .resizable()
                .scaledToFit()
                .blur(radius: 10)
                .overlay {
                  CustomEmptyView(
                    type: .empty(.repartitionStatistics),
                    isDisplayed: !purchasesManager.isCashFlowPro
                  )
                  .shadow(radius: 10)
                }
                .overlay(alignment: .bottom) {
                  AsyncButton {
                      if let product = purchasesManager.products.first {
                        await purchasesManager.buyProduct(product)
                      }
                  } label: {
                    Text("paywall_start_trial".localized)
                      .fontWithLineHeight(.Body.large)
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
          .padding(Padding.large)
          
          Rectangle()
              .frame(height: 120)
              .opacity(0)
        }
      } else {
        CustomEmptyView(
          type: .empty(.analytics),
          isDisplayed: transactionStore.transactions.isEmpty
        )
      }
    } // VStack
    .background(TKDesignSystem.Colors.Background.Theme.bg50)
//    .onChange(of: selectedDate) {
//      if let account = accountStore.selectedAccount, let accountID = account._id {
//        Task {
//          await transactionStore.fetchTransactionsByPeriod(
//            accountID: accountID,
//            startDate: selectedDate,
//            endDate: selectedDate.endOfMonth ?? .now
//          )
//          updateChartData()
//        }
//      }
//    }
//    .onAppear {
//      updateChartData()
//    }
  }
  
  func fetchCashFlow() async {
    if let selectedAccount = accountStore.selectedAccount, let accountID = selectedAccount._id {
      await accountStore.fetchCashFlow(accountID: accountID, year: viewModel.selectedDate.year)
    }
  }
  
}

// MARK: - Preview
#Preview {
  StatisticsScreen()
}
