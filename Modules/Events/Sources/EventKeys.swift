//
//  EventKeys.swift
//  CashFlow
//
//  Created by Theo Sementa on 01/05/2025.
//

import Foundation
import StatsKit

public struct AnalyticsEvent: AppEvent, Sendable {
    public var name: String
    public var path: String
    public var data: [String: String]?
    
    public init(name: String, path: String, data: [String: String]? = nil) {
        self.name = name
        self.path = path
        self.data = data
    }
}

public extension AnalyticsEvent {
    
    static let appSession: AnalyticsEvent = .init(
        name: "app_session",
        path: "/"
    )
    
    static let appPaywall: AnalyticsEvent = .init(
        name: "app_paywall",
        path: "/paywall"
    )
    
}

public extension AnalyticsEvent {
    
    static let userRegisterApple: AnalyticsEvent = .init(
        name: "user_register_apple",
        path: "/login"
    )
    
    static let userRegisterGoogle: AnalyticsEvent = .init(
        name: "user_register_google",
        path: "/login"
    )
    
    static let userLogout: AnalyticsEvent = .init(
        name: "user_logout",
        path: "/settings"
    )
    
    static let userDeleted: AnalyticsEvent = .init(
        name: "user_deleted",
        path: "/settings"
    )
    
}

public extension AnalyticsEvent {
    
    static let preferenceSecurityBiometrie: AnalyticsEvent = .init(
        name: "preference_security_biometrie",
        path: "/settings/security"
    )
    
    static let settingsPage: AnalyticsEvent = .init(
        name: "settings_page",
        path: "/settings"
    )
    
    static let preferenceSecurityReinforced: AnalyticsEvent = .init(
        name: "preference_security_reinforced",
        path: "/settings/security"
    )
    
    static let preferenceAppearanceTint: AnalyticsEvent = .init(
        name: "preference_appearance_tint",
        path: "/settings/appearance"
    )
    
    static let preferenceSubscriptionNotifications: AnalyticsEvent = .init(
        name: "preference_subscription_notifications",
        path: "/settings/subscriptions"
    )
    
    static let preferenceApplePayAutocat: AnalyticsEvent = .init(
        name: "preference_applepay_autocat",
        path: "/settings/applepay"
    )
    
    static let preferenceApplePayPosition: AnalyticsEvent = .init(
        name: "preference_applepay_position",
        path: "/settings/applepay"
    )
    
}

public extension AnalyticsEvent {
    
//    static let accountClassicCreated: AnalyticsEvent = .init(
//        name: "account_classic_created",
//        path: "/add-account"
//    )
//    
//    static let accountClassicDeleted: AnalyticsEvent = .init(
//        name: "account_classic_deleted",
//        path: "/account" // TODO: TODO
//    )
//    
//    static let accountSavingsCreated: AnalyticsEvent = .init(
//        name: "account_savings_created",
//        path: "/add-account"
//    )
//    
//    static let accountSavingsDetailPage: AnalyticsEvent = .init(
//        name: "account_savings_detail_page",
//        path: "/account-details"
//    )
//    
//    static func accountSavingsDeleted(isFromDetails: Bool) -> AnalyticsEvent {
//        return .init(
//            name: "account_savings_deleted",
//            path: isFromDetails ? "/account-details" : "/account-list"
//        )
//    }
    
}

public extension AnalyticsEvent {
    
    static func autocatSuggestionAccepted(isFromDetails: Bool) -> AnalyticsEvent { // TODO: Enable in transaction details
        return .init(
            name: "autocat_suggestion_accepted",
            path: isFromDetails ? "/transaction-details" : "/add-transaction"
        )
    }
    
}

public extension AnalyticsEvent {
    
    static let transactionCreated: AnalyticsEvent = .init(
        name: "transaction_created",
        path: "/add-transaction"
    )
    
}

public enum EventKeys: String {
    
//    case userPremium = "user_premium"
//    
//    case paywallDetailPrediction = "paywall_detail_prediction"
//    case paywallDetailBudgets = "paywall_detail_budgets"
    
    case transactionCreated = "transaction_created"
    case transactionExpenseCreated = "transaction_expense_created"
    case transactionIncomeCreated = "transaction_income_created"
    case transactionCreatedApplePay = "transaction_created_applepay"
    case transactionNoteAdded = "transaction_note_added"
    case transactionUpdated = "transaction_updated"
    case transactionDeleted = "transaction_deleted"
    case transactionDetailPage = "transaction_detail_page"
    case transactionListPage = "transaction_list_page"
    case transactionListPagination = "transaction_list_pagination"
    case transactionCreationCanceled = "transaction_creation_canceled"
    case transactionUpdateCanceled = "transaction_update_canceled"
    
    case subscriptionCreated = "subscription_created"
    case subscriptionUpdated = "subscription_updated"
    case subscriptionDeleted = "subscription_deleted"
    case subscriptionDetailPage = "subscription_detail_page"
    case subscriptionListPage = "subscription_list_page"
    case subscriptionCreationCanceled = "subscription_creation_canceled"
    case subscriptionUpdateCanceled = "subscription_update_canceled"
    
    case sacingsPlanCreated = "savingsplan_created"
    case savingsPlanNoteAdded = "savingsplan_note_added"
    case savingsPlanUpdated = "savingsplan_updated"
    case savingsPlanDeleted = "savingsplan_deleted"
    case savingsplanDetailPage = "savingsplan_detail_page"
    case savingsplanListPage = "savingsplan_list_page"
    case savingsplanCreationCanceled = "savingsplan_creation_canceled"
    case savingsplanUpdateCanceled = "savingsplan_update_canceled"
    
    case contributionCreated = "contribution_created"
    case contributionUpdated = "contribution_updated"
    case contributionDeleted = "contribution_deleted"
    case contributionCreationCanceled = "contribution_creation_canceled"
    
    case creditcardCreated = "creditcard_created"
    case creditcardDeleted = "creditcard_deleted"
    case creditcardCreationCanceled = "creditcard_creation_canceled"
    
    case transferCreated = "transfer_created"
    case transferDeleted = "transfer_deleted"
    case transferDetailPage = "transfer_detail_page"
    case transferCreationCanceled = "transfer_creation_canceled"
    
}
