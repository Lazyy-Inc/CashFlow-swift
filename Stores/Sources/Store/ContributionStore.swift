//
//  ContributionStore.swift
//  Core
//
//  Created by Theo Sementa on 15/08/2025.
//

import Foundation
import Dependencies
import Models
import NetworkModule
import Events

@Observable
public final class ContributionStore {
    public static let shared = ContributionStore()
    
    public var contributions: [ContributionModel] = []
}

public extension ContributionStore {
  
  @MainActor
  func fetchContributions(savingsplanID: Int) async {
      do {
          let contributions = try await NetworkService.sendRequest(
              apiBuilder: ContributionAPIRequester.fetch(savingsplanID: savingsplanID),
              responseModel: [ContributionModel].self
          )
          self.contributions = contributions
          sortContributionsByDate()
      } catch { NetworkService.handleError(error: error) }
  }
  
  @discardableResult
  @MainActor
  func createContribution(savingsplanID: Int, body: ContributionModel) async -> ContributionModel? {
      do {
          let response = try await NetworkService.sendRequest(
              apiBuilder: ContributionAPIRequester.create(savingsplanID: savingsplanID, body: body),
              responseModel: ContributionResponseWithAmount.self
          )
          if let contribution = response.contribution, let newAmount = response.newAmount {
              self.contributions.append(contribution)
              sortContributionsByDate()
              SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
              EventService.sendEvent(key: EventKeys.contributionCreated)
              return contribution
          }
          
          return nil
      } catch {
          NetworkService.handleError(error: error)
          return nil
      }
  }
  
  @MainActor
  func updateContribution(savingsplanID: Int, contributionID: Int, body: ContributionModel) async {
      do {
          let response = try await NetworkService.sendRequest(
              apiBuilder: ContributionAPIRequester.update(savingsplanID: savingsplanID, contributionID: contributionID, body: body),
              responseModel: ContributionResponseWithAmount.self
          )
          if let contribution = response.contribution, let newAmount = response.newAmount {
              if let index = self.contributions.map(\.id).firstIndex(of: contributionID) {
                  self.contributions[index] = contribution
                  sortContributionsByDate()
                  SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
                  EventService.sendEvent(key: EventKeys.contributionUpdated)
              }
          }
      } catch { NetworkService.handleError(error: error) }
  }
  
  @MainActor
  func deleteContribution(savingsplanID: Int, contributionID: Int) async {
      do {
          let response = try await NetworkService.sendRequest(
              apiBuilder: ContributionAPIRequester.delete(savingsplanID: savingsplanID, contributionID: contributionID),
              responseModel: ContributionResponseWithAmount.self
          )
          if let newAmount = response.newAmount {
              SavingsPlanStore.shared.setNewAmount(savingsPlanID: savingsplanID, newAmount: newAmount)
          }
          self.contributions.removeAll(where: { $0.id == contributionID })
          EventService.sendEvent(key: EventKeys.contributionDeleted)
      } catch { NetworkService.handleError(error: error) }
  }
  
}

public extension ContributionStore {
    
    func getContributions(in month: Date? = nil, type: ContributionType? = nil) -> [ContributionModel] {
        return contributions
            .filter { $0.type == type }
            .filter {
                if let month {
                    return Calendar.current.isDate($0.date, equalTo: month, toGranularity: .month)
                } else { return true }
            }
    }
    
    func getAmountOfContributions(in month: Date? = nil) -> Double {
        let additions = getContributions(in: month, type: .addition).compactMap(\.amount).reduce(0, +)
        let withdrawals = getContributions(in: month, type: .withdrawal).compactMap(\.amount).reduce(0, +)
        return additions - withdrawals
    }
  
  private func sortContributionsByDate() {
      self.contributions.sort { $0.date > $1.date }
  }
    
}

// MARK: - Dependencies
extension ContributionStore: DependencyKey {
    public static var liveValue: ContributionStore = .shared
}

public extension DependencyValues {
    var contributionStore: ContributionStore {
        get { self[ContributionStore.self] }
        set { self[ContributionStore.self] = newValue }
    }
}
