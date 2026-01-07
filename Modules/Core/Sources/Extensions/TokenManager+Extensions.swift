//
//  File.swift
//  Core
//
//  Created by Theo Sementa on 30/09/2025.
//

import Foundation
import NetworkKit
import NetworkModule
import Models
import Stores
import Sentry

public extension TokenManager {
    
    @MainActor
    func refreshToken() async throws {
        if let refreshTokenInKeychain = KeychainManager.shared.retrieveItemFromKeychain(
            id: KeychainService.refreshToken.rawValue,
            type: String.self
        ), refreshTokenInKeychain.isEmpty == false {
            do {
                let user = try await NetworkService.sendRequest(
                    apiBuilder: UserAPIRequester.refreshToken(refreshToken: refreshTokenInKeychain),
                    responseModel: UserModel.self
                )
                
                if let refreshToken = user.refreshToken, let token = user.token {
                    self.token = token
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: refreshToken)
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.token.rawValue, data: token)
                    
                    UserStore.shared.currentUser = user
                } else {
                    SentrySDK.capture(message: "Token or refresh token missing in refresh token response")
                    throw NetworkError.refreshTokenFailed
                }
            } catch {
                SentrySDK.capture(error: error)
                SentrySDK.capture(message: "Refresh token failed from API, logging out user")
                UserStore.shared.currentUser = nil
                TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
                throw NetworkError.refreshTokenFailed
            }
        } else {
            SentrySDK.capture(message: "No refresh token found, logging out user")
            UserStore.shared.currentUser = nil
            TokenManager.shared.setTokenAndRefreshToken(token: "", refreshToken: "")
            throw NetworkError.refreshTokenFailed
        }
    }
    
}
