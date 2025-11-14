//
//  AccountEntity+CoreDataProperties.swift
//  CashFlow
//
//  Created by Theo Sementa on 05/10/2025.
//
//

public import Foundation
public import CoreData

@objc(AccountEntity)
public class AccountEntity: NSManagedObject, Identifiable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AccountEntity> {
        return NSFetchRequest<AccountEntity>(entityName: "AccountEntity")
    }

    @NSManaged public var id: UUID
    @NSManaged public var remoteId: Int64
    @NSManaged public var name: String

}

public extension AccountEntity {
  
  func toModel() -> AccountModel? {
    return .init(id: Int(remoteId), name: name)
  }
  
}
