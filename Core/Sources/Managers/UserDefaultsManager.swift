//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 05/10/2025.
//

import Foundation

public enum UserDefaultsKeys: String {
  case transactionFromApplePay
}

public final class UserDefaultsManager {
  
  public static func saveCodable<T: Codable>(key: UserDefaultsKeys, value: T) {
    if let data = try? JSONEncoder().encode(value) {
      UserDefaults.standard.set(data, forKey: key.rawValue)
    }
  }
  
  public static func appendCodable<T: Codable & Equatable>(key: UserDefaultsKeys, value: T) {
    var currentValues = getArrayCodable(key: key, as: T.self)
    if !currentValues.contains(value) {
      currentValues.append(value)
      saveCodable(key: key, value: currentValues)
    }
  }
  
  public static func getArrayCodable<T: Codable>(key: UserDefaultsKeys, as type: T.Type) -> [T] {
    guard let data = UserDefaults.standard.data(forKey: key.rawValue),
          let decoded = try? JSONDecoder().decode([T].self, from: data) else {
      return []
    }
    return decoded
  }
  
  public static func delete(key: UserDefaultsKeys) {
    UserDefaults.standard.removeObject(forKey: key.rawValue)
  }
  
}
