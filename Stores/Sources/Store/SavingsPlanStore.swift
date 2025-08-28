//
//  SavingsPlanStore.swift
//  Core
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies
import Models
import NetworkModule
import EventModule

@Observable
public final class SavingsPlanStore {
    public static let shared = SavingsPlanStore()
    
    public var savingsPlans: [SavingsPlanModel] = []
}

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

public extension SavingsPlanStore {
    
    func setNewAmount(savingsPlanID: Int, newAmount: Double) {
        if let savingsPlanIndex = savingsPlans.firstIndex(where: { $0.id == savingsPlanID }) {
            self.savingsPlans[savingsPlanIndex].currentAmount = newAmount
        }
    }
    
    func reset() {
        self.savingsPlans.removeAll()
    }
    
}

// MARK: - Dependencies
extension SavingsPlanStore: DependencyKey {
    public static var liveValue: SavingsPlanStore = .shared
}

public extension DependencyValues {
    var savingsPlanStore: SavingsPlanStore {
        get { self[SavingsPlanStore.self] }
        set { self[SavingsPlanStore.self] = newValue }
    }
}
