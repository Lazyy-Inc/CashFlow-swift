//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import CoreModule
import NetworkKit
import StatsKit
import EventModule
import Models
import Stores

public extension SavingsPlanStore {
    
    @MainActor
    func fetchSavingsPlans(accountID: Int) async {
        do {
            self.savingsPlans = try await SavingsPlanService.fetchAll(for: accountID)
        } catch { NetworkService.handleError(error: error) }
    }
    
    @discardableResult
    @MainActor
    func createSavingsPlan(accountID: Int, body: SavingsPlanModel) async -> SavingsPlanModel? {
        do {
            let savingsPlan = try await SavingsPlanService.create(accountID: accountID, body: body)
            self.savingsPlans.append(savingsPlan)
            EventService.sendEvent(key: EventKeys.sacingsPlanCreated)
            return savingsPlan
        } catch {
            NetworkService.handleError(error: error)
            return nil
        }
    }
    
    @MainActor
    func updateSavingsPlan(savingsPlanID: Int, body: SavingsPlanModel) async {
        do {
            let savingsPlan = try await SavingsPlanService.update(savingsPlanID: savingsPlanID, body: body)
            if let index = self.savingsPlans.firstIndex(where: { $0.id == savingsPlan.id }) {
                self.savingsPlans[index] = savingsPlan
                EventService.sendEvent(key: EventKeys.savingsPlanUpdated)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
    @MainActor
    func deleteSavingsPlan(savingsPlanID: Int) async {
        do {
            try await SavingsPlanService.delete(savingsPlanID: savingsPlanID)
            if let index = self.savingsPlans.firstIndex(where: { $0.id == savingsPlanID }) {
                self.savingsPlans.remove(at: index)
                EventService.sendEvent(key: EventKeys.savingsPlanDeleted)
            }
        } catch { NetworkService.handleError(error: error) }
    }
    
}
