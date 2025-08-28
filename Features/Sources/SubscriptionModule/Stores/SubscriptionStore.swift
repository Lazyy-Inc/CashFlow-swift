//
//  SubscriptionStore.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/11/2024.
//

import Foundation
import NetworkKit
import StatsKit
import CoreModule
import SwiftUI
import TheoKit
import EventModule
import PreferenceModule
import DesignSystemModule
import Models
import Stores
import NetworkModule

public extension SubscriptionStore {
    
    var subscriptionsByMonth: [Date: [SubscriptionModel]] {
        let groupedByMonth = Dictionary(grouping: subscriptions) { subscription in
            Calendar.current.date(from: Calendar.current.dateComponents([.month, .year], from: subscription.frequencyDate))!
        }
        
        return groupedByMonth
            .sorted { $0.key > $1.key }
            .reduce(into: [Date: [SubscriptionModel]]()) { result, entry in
                result[entry.key] = entry.value
            }
    }
    
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

public extension SubscriptionModel {
    
    var category: CategoryModel? {
        return CategoryStore.shared.findCategoryById(categoryID)
    }
    
    var subcategory: SubcategoryModel? {
        return CategoryStore.shared.findSubcategoryById(subcategoryID)
    }

    var symbol: String {
        switch type {
        case .expense:  return "-"
        case .income:   return "+"
        case .transfer: return ""
        }
    }
    
    var color: Color {
        switch type {
        case .expense:
            return TKDesignSystem.Colors.Error.c500
        case .income:
            return .primary500
        default:
            return .gray
        }
    }
    
    var notifMessage: String {
        let daysBefore = SubscriptionPreferences.shared.dayBeforeReceiveNotification
        let notifMessage = self.type == .expense ? Word.Notifications.willRemoved : Word.Notifications.willAdded
        return "\(self.amount)\(UserCurrency.symbol) \(notifMessage) \(daysBefore) \(Word.Classic.days). (\(self.name))"
    }
    
    var dateNotif: Date {
        var components = Calendar.current.dateComponents([.minute, .hour, .day, .month, .year], from: frequencyDate)
        components.hour = 10
        components.minute = 0
        components.timeZone = TimeZone.current
        return Calendar.current.date(from: components) ?? frequencyDate
    }
}

public extension SubscriptionDTO {
 
    func toModel() throws -> SubscriptionModel {
        guard let id,
              let name,
              let amount,
              let typeNum,
              let frequencyNum,
              let frequencyDate,
              let categoryID else { throw NetworkError.unknown }
        
        guard let type = TransactionType(rawValue: typeNum),
              let frequency = SubscriptionFrequency(rawValue: frequencyNum),
              let date = frequencyDate.toDate() else {
            throw NetworkError.unknown
        }
        
        let transactionModels = try? transactions?.map { try $0.toModel() }
        
        return SubscriptionModel(
            id: id,
            name: name,
            amount: amount,
            type: type,
            frequency: frequency,
            frequencyDate: date,
            categoryID: categoryID,
            subcategoryID: subcategoryID,
            firstSubscriptionDate: firstSubscriptionDate?.toDate(),
            transactions: transactionModels
        )
    }
    
}

public extension SubcategoryDTO {
  
  func toModel() throws -> SubcategoryModel {
    guard let id,
          let name,
          let icon,
          let color,
          let isVisible
    else { throw NetworkError.parsingError }
    
    return SubcategoryModel(
      id: id,
      name: name.localized,
      icon: icon,
      color: Color(hex: color),
      isVisible: isVisible
    )
  }
  
}
