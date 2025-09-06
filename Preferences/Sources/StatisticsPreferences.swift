//
//  File.swift
//  Preferences
//
//  Created by Theo Sementa on 05/09/2025.
//

import Foundation
import Combine
import Events
import Models

public final class StatisticsPreferences: ObservableObject {
  public static let shared = StatisticsPreferences()
  
  public let objectWillChange = PassthroughSubject<Void, Never>()
  
  @UserDefault("StatisticsPreferences_salary", defaultValue: 0)
  public var salary: Double {
    willSet { objectWillChange.send() }
  }
  
  @UserDefault("StatisticsPreferences_repartitionRule", defaultValue: RepartitionRule.rule50_30_20.rawValue)
  public var repartitionRule: String {
    willSet { objectWillChange.send() }
  }
  
}
