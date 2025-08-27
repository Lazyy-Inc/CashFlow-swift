//
//  File.swift
//  DesignSystemModule
//
//  Created by Theo Sementa on 27/08/2025.
//

import Foundation
import Models

extension AccountModel: @retroactive Searchable {
    public var searchableText: String {
        return name
    }
}

extension AccountModel {
    
    public var name: String {
        return self._name ?? ""
    }
    
    public var balance: Double {
        return self._balance ?? 0
    }
    
    public var type: AccountType? {
        guard let typeNum else { return nil }
        return AccountType(rawValue: typeNum)
    }
    
    public var createdAt: Date? {
        guard let createdAtRaw else { return nil }
        return createdAtRaw.toDate()
    }
    
}
