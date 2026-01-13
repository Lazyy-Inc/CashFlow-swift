//
//  AccountPicker.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/11/2024.
//

import SwiftUI
import DesignSystem
import Core
import Models
import Stores

struct AccountPicker: View {
    
    // Builder
    var title: String
    @Binding var selected: AccountModel?
    
    @Dependency(\.accountStore) var accountStore: AccountStore
    @Environment(\.theme) private var theme
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            Picker(selection: $selected) {
                ForEach(accountStore.allAccounts) { account in
                    Button { } label: {
                        Text(account.name)
                        Text(account.balance.toCurrency())
                    }.tag(account)
                }
            } label: {
                Text(selected?.name ?? "")
            }
            .fullWidth(.trailing)
            .tint(theme.color)
            .padding(8)
            .roundedBackground(.field)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    AccountPicker(title: Word.Classic.senderAccount, selected: .constant(.mockClassicAccount))
}
