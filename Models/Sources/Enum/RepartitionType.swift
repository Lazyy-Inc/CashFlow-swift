//
//  File.swift
//  Models
//
//  Created by Theo Sementa on 02/09/2025.
//

import Foundation

public enum RepartitionType: String, CaseIterable, Sendable, Nameable {
    case notDefined
    case needed
    case wanted
    case saved
    
    public var name: String {
        switch self {
        case .notDefined:
            return "repartition_type_not_defined"
        case .needed:
            return "repartition_type_needed"
        case .wanted:
            return "repartition_type_wanted"
        case .saved:
            return "repartition_type_saved"
        }
    }
}
