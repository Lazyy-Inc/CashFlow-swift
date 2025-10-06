//
//  File.swift
//  Stores
//
//  Created by Theo Sementa on 06/10/2025.
//

import Foundation
import Models

final class TransactionStoreMock: TransactionStoreProtocol {
  var transactions: [TransactionModel] = []
  
  var currentDateForFetch: Date = Date()
  
  var dateFetched: [Date] = []
  
}

// MARK: - CRUD
extension TransactionStoreMock {
  
  func fetchTransactionsByPeriod(accountId: Int, period: PeriodDateModel, type: TransactionType?) async {
    
  }
  
  func createTransaction(accountId: Int, body: TransactionDTO, shouldStore: Bool) async -> TransactionModel? {
    return nil
  }
  
  func updateTransaction(accountId: Int, transactionId: Int, body: TransactionDTO) async -> TransactionModel? {
    return nil
  }
  
  func deleteTransaction(transactionId: Int) async {
    
  }
  
}

// MARK: - Utilities
extension TransactionStoreMock {
  
  func fetchRecommendedCategory(name: String, transactionId: Int?) async -> TransactionFetchCategoryResponse? {
    return nil
  }
  
}
