//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 06/10/2025.
//

import Foundation
import Models

public protocol TransactionStoreProtocol {
  var transactions: [TransactionModel] { get set }
  var currentDateForFetch: Date { get set }
  var dateFetched: [Date] { get set }

  func fetchTransactionsByPeriod(accountId: Int, period: PeriodDateModel, type: TransactionType?) async
  func createTransaction(accountId: Int, body: TransactionDTO, shouldStore: Bool) async -> TransactionModel?
  func updateTransaction(accountId: Int, transactionId: Int, body: TransactionDTO) async -> TransactionModel?
  func deleteTransaction(transactionId: Int) async

  func fetchRecommendedCategory(name: String, transactionId: Int?) async -> TransactionFetchCategoryResponse?
  
}

// TODO: TODO
//public extension TransactionStoreProtocol {
//  
//  func reset() {
//    transactions.removeAll()
//    dateFetched.removeAll()
//  }
//  
//}
