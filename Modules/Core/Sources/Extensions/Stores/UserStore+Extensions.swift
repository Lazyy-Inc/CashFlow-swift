//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 30/09/2025.
//

import Foundation
import Stores
import NetworkModule

public extension UserStore {
    
    @MainActor
    func loginWithToken() async throws {
        try await TokenManager.shared.refreshToken()
    }
    
}
