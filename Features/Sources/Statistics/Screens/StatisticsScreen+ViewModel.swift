//
//  StatisticsScreen+ViewModel.swift
//  Features
//
//  Created by Theo Sementa on 03/09/2025.
//

import Foundation
import Models
import Stores
import DesignSystem
import SwiftUI

// MARK: - Stored variables
extension StatisticsScreen {
  
  @Observable
  final class ViewModel {
    let transactionStore: TransactionStore = .shared
    
    var repartitionDate: Date = Date()
    
    var selectedDate: Date = Date()
    var selectedYear: Int = Date().year
    var amount: Double = 0
  }
  
}

// MARK: - Computed variables
extension StatisticsScreen.ViewModel {
  
  var expensesOfTheMonth: Double {
    return transactionStore.getTransactions(in: repartitionDate, type: .expense)
      .reduce(0) { $0 + $1.amount }
  }
  
  var slices: [PieSliceData] {
    let neededSlice = PieSliceData(
      title: RepartitionType.needed.name,
      value: neededAmount,
      color: Color.Category.categoryHealth
    )
    
    let wantedSlice = PieSliceData(
      title: RepartitionType.wanted.name,
      value: wantedAmount,
      color: Color.Category.categoryLeisure
    )
    
    let savedSlice = PieSliceData(
      title: RepartitionType.saved.name,
      value: savedAmount,
      color: Color.Category.categorySavings
    )
    
    return [neededSlice, wantedSlice, savedSlice]
  }
  
  var neededTransactions: [TransactionModel] {
    return transactionStore.getTransactions(in: repartitionDate, type: .expense)
      .filter { $0.repartitionType == .needed }
  }
  
  var wantedTransactions: [TransactionModel] {
    return transactionStore.getTransactions(in: repartitionDate, type: .expense)
      .filter { $0.repartitionType == .wanted }
  }
  
  var savedTransactions: [TransactionModel] {
    return transactionStore.getTransactions(in: repartitionDate, type: .expense)
      .filter { $0.repartitionType == .saved }
  }
  
  var neededAmount: Double {
    return neededTransactions.reduce(0) { $0 + $1.amount }
  }
  
  var wantedAmount: Double {
    return wantedTransactions.reduce(0) { $0 + $1.amount }
  }
  
  var savedAmount: Double {
    return savedTransactions.reduce(0) { $0 + $1.amount }
  }
  
}

// MARK: - Public functions
extension StatisticsScreen.ViewModel {
    
  func fetchTransactions(for date: Date) async {
//    let transactionStore: TransactionStore = .shared
//    let accountStore: AccountStore = .shared
//
//    guard let accountId = accountStore.selectedAccount?._id else { return }
//    guard let startOfMonth = date.startOfMonth, let endOfMonth = date.endOfMonth else { return }
//
//    await transactionStore.fetchTransactionsByPeriod(
//      accountID: accountId,
//      startDate: startOfMonth,
//      endDate: endOfMonth,
//      type: .expense
//    )
  }
  
}
