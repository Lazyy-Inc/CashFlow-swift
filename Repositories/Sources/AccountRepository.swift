//
//  AccountRepository.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/10/2025.
//

import Foundation
import Models
import Persistence

@MainActor
public final class AccountRepository {

  public static func fetchAll() async throws -> [AccountEntity] {
    let request = AccountEntity.fetchRequest()
    do {
      let accounts = try CoreDataStack.shared.context.fetch(request)
      return accounts
    } catch {
      return []
    }
    
  }
  
  public static func create(remoteId: Int, name: String) {
    let context = CoreDataStack.shared.context
    let account = AccountEntity(context: context)
    account.id = UUID()
    account.remoteId = Int64(remoteId)
    account.name = name
    CoreDataStack.shared.saveContext()
  }
  
}
