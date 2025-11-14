//
//  AddTransactionIntent.swift
//  CashFlow
//
//  Created by Theo Sementa on 13/10/2023.
//  Localized with Toglee on 16/04/2025

import AppIntents
import Core
import Preferences
import Sentry
import Models
import Stores
import Repositories
import NotificationKit
import UserNotifications
import Utilities

struct AddTransactionIntent: AppIntent {
    
    static let title: LocalizedStringResource = "shortcut_title"
    static let description: LocalizedStringResource = "shortcut_desccription"
    
    @Parameter(
        title: "shortcut_parameter_title_title",
        description: "shortcut_parameter_title_description",
        requestValueDialog: "shortcut_parameter_title_dialog"
    )
    var title: String
    
    @Parameter(
        title: "shortcut_parameter_amount_title",
        description: "shortcut_parameter_amount_description",
        inputOptions: .init(keyboardType: .numberPad),
        requestValueDialog: "shortcut_parameter_amount_dialog"
    )
    var amount: String
    
    @Parameter(
        title: "shortcut_parameter_account_title",
        description: "shortcut_parameter_account_description",
        requestValueDialog: "shortcut_parameter_account_dialog"
    )
    var account: AccountEntity?
    
    func perform() async throws -> some IntentResult & ProvidesDialog {
              
        func extractAmount(from input: String) -> Double {
            let allowedCharacters = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
            let filtered = input.components(separatedBy: allowedCharacters.inverted).joined()
            let normalized = filtered.replacingOccurrences(of: ",", with: ".")
            return normalized.toDouble()
        }
          
        let finalNumber = extractAmount(from: amount)
        let stringNumber = finalNumber.toString(minDigits: 2)
            
        var body: TransactionDTO = .init(
            name: title,
            amount: finalNumber,
            type: TransactionType.expense.rawValue,
            dateISO: Date().toISO(),
            categoryID: 0, // Saw with Remi it's 0 for uncategorized
            isFromApplePay: true,
            nameFromApplePay: title,
            autoCat: PreferencesApplePay.shared.isAddCategoryAutomaticallyEnabled,
            accountId: Int(account?.remoteId ?? 0)
        ) 
              
        if PreferencesApplePay.shared.isAddAddressAutomaticallyEnabled && LocationManager.shared.isLocationEnabled {
            let location = LocationManager.shared.getCurrentLocation()
            if let location, let address = try await LocationManager.shared.getCurrentAddress(location: location) {
                body.address = address
                body.lat = location.coordinate.latitude
                body.long = location.coordinate.longitude
            }
        }
          
        UserDefaultsManager.appendCodable(key: .transactionFromApplePay, value: body)
      
        let notificationData = NotificationData(
          id: UUID().uuidString,
          title: "CashFlow",
          message: String(format: "notification_apple_pay_payed".localized, "\(stringNumber)\(UserCurrency.symbol)", title)
        )
        await NotificationsManager.shared.scheduleNotification(for: notificationData, in: 10)
              
        let formatString = "shortcut_result_label".localized
        let formattedText = String(format: formatString, stringNumber, UserCurrency.symbol, title)
        
        return .result(dialog: IntentDialog(stringLiteral: formattedText))
    }
    
}

extension AccountEntity: @retroactive AppEntity, @unchecked Sendable {
    public static var typeDisplayRepresentation: TypeDisplayRepresentation {
        return TypeDisplayRepresentation(name: "AccountEntity")
    }
    
    public static var defaultQuery = AccountQuery()
    
    public var displayRepresentation: DisplayRepresentation {
        return DisplayRepresentation(
            title: "\(name)"
        )
    }
        
    public var entityID: String {
      return String(remoteId)
    }
}

// Create a query to fetch all accounts
public struct AccountQuery: EntityQuery {
    public init() { }
    
    @MainActor
    public func entities(for identifiers: [AccountEntity.ID]) async throws -> [AccountEntity] {
      let accounts = try await AccountRepository.fetchAll()
      return accounts
    }
    
    @MainActor
    public func suggestedEntities() async throws -> [AccountEntity] {
      let accounts = try await AccountRepository.fetchAll()
      return accounts
    }
  
}
