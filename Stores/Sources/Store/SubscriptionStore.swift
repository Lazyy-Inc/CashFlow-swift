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
import Events

@Observable
public final class SubscriptionStore {
    public static let shared = SubscriptionStore()
    
    public var subscriptions: [SubscriptionModel] = []
}

public extension SubscriptionStore {
    
    func fetchSubscriptions(accountID: Int) async {
        do {
            let subscriptions = try await SubscriptionService.fetchAll(for: accountID).map { try $0.toModel() }
            await MainActor.run {
                self.subscriptions = subscriptions
                sortSubscriptionsByDate()
            }
        } catch { await NetworkService.handleError(error: error) }
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
            await NetworkService.handleError(error: error)
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
            await NetworkService.handleError(error: error)
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
        } catch { await NetworkService.handleError(error: error) }
    }
}

public extension SubscriptionStore {
    
    func reset() {
        subscriptions.removeAll()
    }
    
    private func sortSubscriptionsByDate() {
        self.subscriptions.sort { $0.frequencyDate < $1.frequencyDate }
    }
    
    func getSubscriptions(in date: Date) -> [SubscriptionModel] {
        return self.subscriptions
            .filter { Calendar.current.isDate($0.frequencyDate, equalTo: date, toGranularity: .month) }
    }
    
    func getTransactionsWithDate(for date: Date) -> [Date: [TransactionModel]] {
        var transactionsWithDate: [Date: [TransactionModel]] = [:]
        
        for subscription in self.subscriptions {
            switch subscription.frequency {
            case .monthly:
                let realDate = subscription.frequencyDate
                var dateForTheMonth = DateComponents()
                dateForTheMonth.day = realDate.dayValue
                dateForTheMonth.month = date.monthValue
                dateForTheMonth.year = date.yearValue
                
                if let composedDate = Calendar.current.date(from: dateForTheMonth) {
                    var transaction = subscription.toTransactionModel()
                    transaction.date = composedDate
                    transactionsWithDate[composedDate, default: []].append(transaction)
                }
            case .yearly:
                if let lastSubscriptionDate = subscription.lastSubscriptionDate,
                   Calendar.current.isDate(lastSubscriptionDate, equalTo: date, toGranularity: .month) {
                    var transaction = subscription.toTransactionModel()
                    transaction.date = Calendar.current.startOfDay(for: lastSubscriptionDate)
                    transactionsWithDate[transaction.date, default: []].append(transaction)
                }
                if Calendar.current.isDate(subscription.frequencyDate, equalTo: date, toGranularity: .month) {
                    var transaction = subscription.toTransactionModel()
                    transaction.date = Calendar.current.startOfDay(for: subscription.frequencyDate)
                    transactionsWithDate[transaction.date, default: []].append(transaction)
                }
            case .weekly:
                let calendar = Calendar.current
                let monthStart = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
                let monthEnd = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: monthStart)!

                // Récupérer le jour de la semaine de la subscription
                let subscriptionWeekday = calendar.component(.weekday, from: subscription.frequencyDate)

                // D'abord, ajouter la frequencyDate si elle est dans le mois
                let frequencyDateStart = calendar.startOfDay(for: subscription.frequencyDate)
                if frequencyDateStart >= monthStart && frequencyDateStart <= monthEnd {
                    var transaction = subscription.toTransactionModel()
                    transaction.date = frequencyDateStart
                    transactionsWithDate[frequencyDateStart, default: []].append(transaction)
                }

                // Ensuite, chercher tous les autres jours correspondant dans le mois
                var currentDate = monthStart
                while currentDate <= monthEnd {
                    let currentWeekday = calendar.component(.weekday, from: currentDate)
                    
                    if currentWeekday == subscriptionWeekday && currentDate > subscription.frequencyDate {
                        var transaction = subscription.toTransactionModel()
                        transaction.date = calendar.startOfDay(for: currentDate)
                        transactionsWithDate[transaction.date, default: []].append(transaction)
                    }
                    
                    // Passer au jour suivant
                    if let nextDate = calendar.date(byAdding: .day, value: 1, to: currentDate) {
                        currentDate = nextDate
                    } else {
                        break
                    }
                }
            }
        }
        
        return transactionsWithDate
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
