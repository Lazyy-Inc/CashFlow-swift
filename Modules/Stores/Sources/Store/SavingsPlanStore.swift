//
//  SavingsPlanStore.swift
//  Core
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies
import Models
import Networking
import Events

@Observable
public final class SavingsPlanStore {
    public static let shared = SavingsPlanStore()
    
    public var savingsPlans: [SavingsPlanModel] = []
}

public extension SavingsPlanStore {
    
    var savingsAmount: Double {
        return savingsPlans
            .compactMap(\.currentAmount)
            .reduce(0, +)
    }
    
}

public extension SavingsPlanStore {
  
  @MainActor
  func fetchSavingsPlans() async {
      do {
          self.savingsPlans = try await SavingsPlanService.fetchAll()
      } catch { await NetworkService.handleError(error: error) }
  }
  
  @discardableResult
  @MainActor
  func createSavingsPlan(body: SavingsPlanModel) async -> SavingsPlanModel? {
      do {
          let savingsPlan = try await SavingsPlanService.create(body: body)
          self.savingsPlans.append(savingsPlan)
          // EventService.sendEvent(key: EventKeys.sacingsPlanCreated)
          return savingsPlan
      } catch {
          await NetworkService.handleError(error: error)
          return nil
      }
  }
  
  @MainActor
  func updateSavingsPlan(savingsPlanID: Int, body: SavingsPlanModel) async {
      do {
          let savingsPlan = try await SavingsPlanService.update(savingsPlanID: savingsPlanID, body: body)
          if let index = self.savingsPlans.firstIndex(where: { $0.id == savingsPlan.id }) {
              self.savingsPlans[index] = savingsPlan
              // EventService.sendEvent(key: EventKeys.savingsPlanUpdated)
          }
      } catch { await NetworkService.handleError(error: error) }
  }
  
  @MainActor
  func deleteSavingsPlan(savingsPlanID: Int) async {
      do {
          try await SavingsPlanService.delete(savingsPlanID: savingsPlanID)
          if let index = self.savingsPlans.firstIndex(where: { $0.id == savingsPlanID }) {
              self.savingsPlans.remove(at: index)
              // EventService.sendEvent(key: EventKeys.savingsPlanDeleted)
          }
      } catch { await NetworkService.handleError(error: error) }
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
