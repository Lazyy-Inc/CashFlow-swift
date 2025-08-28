//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models
import Stores
import Core

extension TransactionModel: @retroactive Searchable {
    public var searchableText: String {
        return nameDisplayed
    }
}

public extension TransactionModel {
  
  var isSender: Bool {
    guard let selectedAccount = AccountStore.shared.selectedAccount else { return false }
    return senderAccount?.id == selectedAccount.id
  }
  
  var nameDisplayed: String {
    switch type {
    case .expense, .income:
      return self.name
    case .transfer:
      guard let senderAccount, let receiverAccount else { return "" }
      
      if isSender {
        let receiverAccountName = receiverAccount.name
        return [Word.Classic.sent, Word.Preposition.to, receiverAccountName].joined(separator: " ")
      } else {
        let senderAccountName = senderAccount.name
        return [Word.Classic.received, Word.Preposition.from, senderAccountName].joined(separator: " ")
      }
    }
  }
  
  var symbol: String {
    switch type {
    case .expense:  return "-"
    case .income:   return "+"
    case .transfer:
      if isSender {
        return "-"
      } else {
        return "+"
      }
    }
  }
  
}
