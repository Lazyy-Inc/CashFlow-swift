//
//  SavingsPlanService.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/01/2025.
//

import Foundation
import NetworkKit
import CoreModule

public struct SavingsPlanService {
    
    public static func fetchAll(for accountID: Int) async throws -> [SavingsPlanModel] {
        return try await NetworkService.sendRequest(
            apiBuilder: SavingsPlanAPIRequester.fetch(accountID: accountID),
            responseModel: [SavingsPlanModel].self
        )
    }
    
    public static func create(accountID: Int, body: SavingsPlanModel) async throws -> SavingsPlanModel {
        return try await NetworkService.sendRequest(
            apiBuilder: SavingsPlanAPIRequester.create(accountID: accountID, body: body),
            responseModel: SavingsPlanModel.self
        )
    }
    
    public static func update(savingsPlanID: Int, body: SavingsPlanModel) async throws -> SavingsPlanModel {
        return try await NetworkService.sendRequest(
            apiBuilder: SavingsPlanAPIRequester.update(savingsplanID: savingsPlanID, body: body),
            responseModel: SavingsPlanModel.self
        )
    }
    
    public static func delete(savingsPlanID: Int) async throws {
        try await NetworkService.sendRequest(
            apiBuilder: SavingsPlanAPIRequester.delete(savingsplanID: savingsPlanID)
        )
    }
    
}
