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
import TheoKit
import DesignSystem
import Core
import Dependencies
import Events
import Models
import Mocks
import Stores

public struct TransactionDetailsScreen: View {
  
  // MARK: Dependencies
  var transaction: TransactionModel
  @Dependency(\.transactionStore) private var transactionStore: TransactionStore
  @Dependency(\.categoryStore) private var categoryStore
  
  // MARK: Environments
  @EnvironmentObject private var router: Router<AppDestination>
  @EnvironmentObject var store: PurchasesManager
  @Environment(\.dismiss) private var dismiss
  
  @StateObject var viewModel: ViewModel = .init()
  
  var currentTransaction: TransactionModel {
    return transactionStore.transactions.first { $0.id == transaction.id } ?? transaction
  }
  
  public init(transaction: TransactionModel) {
    self.transaction = transaction
  }
  
  // MARK: -
  public var body: some View {
    BetterScrollView(maxBlurRadius: Blur.topbar) {
      NavigationBarWithMenu {
        NavigationButtonView(
          route: .push,
          destination: AppDestination.transaction(.update(transaction: currentTransaction))
        ) {
          Label(Word.Classic.edit, systemImage: "pencil")
        }
        
        Button(
          role: .destructive,
          action: { AlertManager.shared.deleteTransaction(transaction: currentTransaction, dismissAction: dismiss) },
          label: { Label(Word.Classic.delete, systemImage: "trash.fill") }
        )
      }
    } content: { _ in
      VStack(spacing: Spacing.extraLarge) {
        VStack(spacing: Spacing.small) {
          VStack(spacing: Spacing.extraSmall) {
            Text("\(currentTransaction.symbol) \(currentTransaction.amount.toCurrency())")
              .fontWithLineHeight(.Display.huge)
              .foregroundColor(currentTransaction.color)
            
            Text(currentTransaction.nameDisplayed)
              .fontWithLineHeight(.Display.small)
              .multilineTextAlignment(.center)
              .lineLimit(2)
          }
          if currentTransaction.isFromSubscription == true {
            Text("transaction_detail_automatically_created".localized)
              .font(.mediumText16())
          }
        }
        
        if let categoryFound = viewModel.bestCategory {
          let subcategoryFound = viewModel.bestSubcategory
          PredictedCategoryRowView(
            category: categoryFound,
            subcategory: subcategoryFound,
            action: {
              viewModel.selectedCategory = categoryFound
              if let subcategoryFound { viewModel.selectedSubcategory = subcategoryFound }
              viewModel.updateCategory(transactionID: currentTransaction.id)
            }
          )
        }
        
        VStack(spacing: Spacing.medium) {
          DetailRow(
            icon: "iconCalendar",
            text: "transaction_detail_date".localized,
            value: currentTransaction.date.formatted(
              date: .complete,
              time: currentTransaction.isFromApplePay == true ? .shortened : .omitted
            ).capitalized
          )
          
          if let category = currentTransaction.category {
            DetailRow(
              icon: category.icon,
              value: category.name,
              iconBackgroundColor: category.color,
              isCategory: true
            ) {
              presentChangeCategory()
            }
            
            if let subcategory = currentTransaction.subcategory {
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
          
          DetailRow(
            icon: "iconPieChart",
            text: "repartition_picker_title".localized,
            value: currentTransaction.repartitionType?.name ?? "-"
          )
          
          if let senderAccount = currentTransaction.senderAccount {
            DetailRow(
              icon: "iconSend",
              text: Word.Classic.senderAccount,
              value: senderAccount.name
            )
          }
          
          if let receiverAccount = currentTransaction.receiverAccount {
            DetailRow(
              icon: "iconInbox",
              text: Word.Classic.receiverAccount,
              value: receiverAccount.name
            )
          }
          
          TransactionDetailNoteRowView(note: $viewModel.note)
          
          if currentTransaction.lat != nil && currentTransaction.long != nil {
            if #available(iOS 17.0, *) {
              TransactionMapRow(transaction: currentTransaction)
            } else {
              // Fallback on earlier versions
            }
          }
        }
      }
      .padding(.horizontal, Padding.large)
    } // Content ScrollView
    .onAppear {
      viewModel.note = currentTransaction.note ?? ""
      if transaction.type == .transfer {
        EventService.sendEvent(key: EventKeys.transferDetailPage)
      } else {
        EventService.sendEvent(key: EventKeys.transactionDetailPage)
      }
    }
    .task {
      if store.isCashFlowPro && currentTransaction.category?.id == 0 {
        guard !currentTransaction.nameDisplayed.isBlank else { return }
        let transactionID = currentTransaction.id
        if let response = await transactionStore.fetchCategory(name: currentTransaction.nameDisplayed, transactionID: transactionID) {
          if let cat = response.cat {
            viewModel.bestCategory = categoryStore.findCategoryById(cat)
          }
          if let sub = response.sub {
            viewModel.bestSubcategory = categoryStore.findSubcategoryById(sub)
          }
        }
      }
    }
    .onDisappear {
      if viewModel.note != currentTransaction.note && !viewModel.note.isBlank {
        viewModel.updateTransaction(transactionID: currentTransaction.id)
        EventService.sendEvent(key: EventKeys.transactionNoteAdded)
      }
    }
    .navigationBarBackButtonHidden(true)
    .toolbarBackground(Color.clear, for: .navigationBar)
    .toolbar(.hidden, for: .navigationBar)
    .background(TKDesignSystem.Colors.Background.Theme.bg50)
  } // body
} // struct

// MARK: - Utils
extension TransactionDetailsScreen {
  
  func presentChangeCategory() {
    router.present(
      route: .sheet,
      .category(.select(
        selectedCategory: $viewModel.selectedCategory,
        selectedSubcategory: $viewModel.selectedSubcategory
      ))
    ) {
      if viewModel.selectedCategory != nil {
        viewModel.updateCategory(transactionID: currentTransaction.id)
      }
    }
  }
  
}

// MARK: - Preview
#Preview {
  NavigationStack {
    TransactionDetailsScreen(transaction: .mockClassicTransaction)
  }
  .environmentObject(PurchasesManager())
  .environmentObject(ThemeManager.shared)
}
