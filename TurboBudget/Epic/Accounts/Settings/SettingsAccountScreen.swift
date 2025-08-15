//
//  SettingsAccountScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 28/04/2025.
//

import SwiftUI
import CoreModule

struct SettingsAccountScreen: View {
    
    @StateObject private var preferencesAccount: AccountPreferences = .shared
    
    @EnvironmentObject private var accountStore: AccountStore
    
    // MARK: -
    var body: some View {
        Form {
            Section {
                Picker("word_main_account".localized, selection: $preferencesAccount.mainAccountId) {
                    ForEach(accountStore.classicAccounts) { account in
                        Text(account.name).tag(account._id ?? 0)
                    }
                }
            }
        }
        .navigationTitle("word_account".localized)
        .navigationBarTitleDisplayMode(.inline)
        .onChangeAsync(of: preferencesAccount.mainAccountId) {
            await accountStore.updateAccount(accountID: $0, body: .init(isMain: true))
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    SettingsAccountScreen()
}
