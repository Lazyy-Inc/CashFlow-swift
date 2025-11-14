//
//  PieSliceData.swift
//  CustomPieChart
//
//  Created by Theo Sementa on 10/08/2024.
//

import Foundation
import SwiftUI

public struct PieSliceData: Hashable {
  public var title: String
  public var icon: String?
  public var value: Double
  public var color: Color
  
  public init(title: String, icon: String? = nil, value: Double, color: Color) {
    self.title = title
    self.icon = icon
    self.value = value
    self.color = color
  }
}
