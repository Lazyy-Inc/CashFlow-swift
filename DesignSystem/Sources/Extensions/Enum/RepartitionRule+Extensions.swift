//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 05/09/2025.
//

import Foundation
import Models

public extension RepartitionRule {
  
  var ruleFormatted: String {
    return self.rawValue.replacingOccurrences(of: "-", with: "/")
  }
  
  var neededPercentage: Int {
    return Int(self.rawValue.components(separatedBy: "-").first ?? "") ?? 0
  }
  
  var wantedPercentage: Int {
    return Int(self.rawValue.components(separatedBy: "-")[safe: 1] ?? "") ?? 0
  }
  
  var savedPercentage: Int {
    return Int(self.rawValue.components(separatedBy: "-").last ?? "") ?? 0
  }
  
}
