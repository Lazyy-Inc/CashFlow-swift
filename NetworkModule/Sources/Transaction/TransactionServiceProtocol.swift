//
//  File.swift
//  NetworkModule
//
//  Created by Theo Sementa on 07/10/2025.
//

import Foundation
import Models

public protocol TransactionServiceProtocol {
  static func fetchTransactionsByPeriod(
    accountID: Int,
    period: PeriodDateModel,
    type: TransactionType?
  ) async throws -> [TransactionDTO]
  
  static func create(
    accountID: Int,
    body: TransactionDTO
  ) async throws -> TransactionResponseWithBalance

  static func update(
    transactionID: Int,
    body: TransactionDTO
  ) async throws -> TransactionResponseWithBalance
  
  static func delete(
    transactionID: Int
  ) async throws -> TransactionResponseWithBalance
  
  static func fetchRecommendedCategory(
    name: String,
    transactionID: Int?
  ) async throws -> TransactionFetchCategoryResponse
}
