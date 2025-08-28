//
//  UserService.swift
//  CashFlow
//
//  Created by Theo Sementa on 29/04/2025.
//

import Foundation
import NetworkKit
import Models

public struct UserService {
  
  public static func update(body: UserModel) async throws -> UserModel {
    return try await NetworkService.sendRequest(
      apiBuilder: UserAPIRequester.update(body: body),
      responseModel: UserModel.self
    )
  }
  
}
