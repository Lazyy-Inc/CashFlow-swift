//
//  SubscriptionStore.swift
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
public final class SubscriptionStore {
  public static let shared = SubscriptionStore()
  
  public var subscriptions: [SubscriptionModel] = []
}

public extension SubscriptionStore {
  @MainActor
  func fetchSubscriptions(accountID: Int) async {
    do {
      self.subscriptions = try await SubscriptionService.fetchAll(for: accountID).map { try $0.toModel() }
      sortSubscriptionsByDate()
    } catch { NetworkService.handleError(error: error) }
  }
  
  @discardableResult
  @MainActor
  func createSubscription(accountID: Int, body: SubscriptionDTO, shouldReturn: Bool = false) async -> SubscriptionModel? {
    do {
      let subscription = try await SubscriptionService.create(accountID: accountID, body: body).toModel()
      self.subscriptions.append(subscription)
      sortSubscriptionsByDate()
      EventService.sendEvent(key: EventKeys.subscriptionCreated)
      return shouldReturn ? subscription : nil
    } catch {
      NetworkService.handleError(error: error)
      return nil
    }
  }
  
  @discardableResult
  @MainActor
  func updateSubscription(subscriptionID: Int, body: SubscriptionDTO) async -> SubscriptionModel? {
    do {
      let subscription = try await SubscriptionService.update(subscriptionID: subscriptionID, body: body).toModel()
      if let index = self.subscriptions.firstIndex(where: { $0.id == subscriptionID }) {
        self.subscriptions[index] = subscription
        sortSubscriptionsByDate()
        EventService.sendEvent(key: EventKeys.subscriptionUpdated)
      }
      return subscription
    } catch {
      NetworkService.handleError(error: error)
      return nil
    }
  }
  
  @MainActor
  func deleteSubscription(subscriptionID: Int) async {
    do {
      try await SubscriptionService.delete(subscriptionID: subscriptionID)
      if let index = self.subscriptions.firstIndex(where: { $0.id == subscriptionID }) {
        self.subscriptions.remove(at: index)
        EventService.sendEvent(key: EventKeys.subscriptionDeleted)
      }
    } catch { NetworkService.handleError(error: error) }
  }
}

public extension SubscriptionStore {
  
  func reset() {
    subscriptions.removeAll()
  }
  
  private func sortSubscriptionsByDate() {
      self.subscriptions.sort { $0.frequencyDate < $1.frequencyDate }
  }
  
}

// MARK: - Dependencies
extension SubscriptionStore: DependencyKey {
  public static var liveValue: SubscriptionStore = .shared
}

public extension DependencyValues {
  var subscriptionStore: SubscriptionStore {
    get { self[SubscriptionStore.self] }
    set { self[SubscriptionStore.self] = newValue }
  }
}
