//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 02/09/2025.
//

import Foundation
import Models

extension RepartitionType: @retroactive Nameable {
  public var name: String {
    switch self {
    case .notDefined:
      return "repartition_type_not_defined".localized
    case .needed:
      return "repartition_type_needed".localized
    case .wanted:
      return "repartition_type_wanted".localized
    case .saved:
      return "repartition_type_saved".localized
    }
  }
}
