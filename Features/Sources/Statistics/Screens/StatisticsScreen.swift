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

public struct StatisticsScreen: View {
  
  @State private var viewModel: ViewModel = .init()
  
  @Dependency(\.transactionStore) private var transactionStore: TransactionStore
  @EnvironmentObject private var router: Router<AppDestination>
  
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
            RepartitionStatisticsCellView(
              date: $viewModel.repartitionDate,
              slices: viewModel.slices
            )
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
}

// MARK: - Preview
#Preview {
  StatisticsScreen()
}
