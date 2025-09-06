//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 05/09/2025.
//

import Foundation

public extension Collection {
  
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
  
}
