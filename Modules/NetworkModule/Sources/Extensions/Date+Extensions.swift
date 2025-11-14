//
//  File.swift
//  NetworkModule
//
//  Created by Theo Sementa on 28/08/2025.
//

import Foundation

extension Date {
  func toQueryParam() -> String {
      let formatter = DateFormatter()
      formatter.timeZone = TimeZone(identifier: "UTC")
      formatter.locale = Locale(identifier: "en_US_POSIX")
      formatter.dateFormat = "yyyy-MM-dd"
      return formatter.string(from: self)
  }
}
