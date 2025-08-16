//
//  AccountPreferences.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/04/2025.
//

import Foundation
import Combine

public final class AccountPreferences: ObservableObject {
    public static let shared = AccountPreferences()
    
    public let objectWillChange = PassthroughSubject<Void, Never>()
    
    @UserDefault("PreferencesAccount_mainAccountId", defaultValue: 0)
    public var mainAccountId: Int {
        willSet { objectWillChange.send() }
    }
    
}
