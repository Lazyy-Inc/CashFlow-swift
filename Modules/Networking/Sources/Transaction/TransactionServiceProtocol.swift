//
//  File.swift
//  NetworkModule
//
//  Created by Theo Sementa on 07/10/2025.
//

import Foundation
import Models

public protocol TransactionServiceProtocol {
    func fetchTransactionsByPeriod(
        accountID: Int,
        period: PeriodDateModel,
        type: FinancialItemType?
    ) async throws -> [TransactionDTO]
    
    func create(
        accountID: Int,
        body: TransactionDTO
    ) async throws -> TransactionResponseWithBalance
    
    func update(
        transactionID: Int,
        body: TransactionDTO
    ) async throws -> TransactionResponseWithBalance
    
    func delete(
        transactionID: Int
    ) async throws -> TransactionResponseWithBalance
    
    func fetchRecommendedCategory(
        name: String,
        transactionID: Int?
    ) async throws -> TransactionFetchCategoryResponse
}
