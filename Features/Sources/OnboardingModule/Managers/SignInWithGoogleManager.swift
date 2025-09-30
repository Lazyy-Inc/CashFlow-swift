//
//  SignInWithGoogleManager.swift
//  Split
//
//  Created by Theo Sementa on 29/05/2024.
//

// https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed
// https://github.com/google/GoogleSignIn-iOS/issues/378
import SwiftUI
import GoogleSignIn
import Core
import Preferences
import Events
import NetworkModule
import Models
import Stores

class SignInWithGoogleManager {
  
  @MainActor
  static func signIn() {
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController
    else { return }
    
    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { user, error in
      if let error {
        print("⚠️ Google Error: \(error.localizedDescription)")
        return
      }
      
      guard let user else { return }
      guard let googleToken = user.user.idToken else { return }
      
      Task {
        let user = try await NetworkService.sendRequest(
          apiBuilder: AuthAPIRequester.google(body: .init(identityToken: googleToken.tokenString)),
          responseModel: UserModel.self
        )
        
        if let token = user.token, let refreshToken = user.refreshToken {
          TokenManager.shared.setTokenAndRefreshToken(token: token, refreshToken: refreshToken)
          UserStore.shared.currentUser = user
          PreferencesGeneral.shared.isAlreadyOpen = true
          await MainActor.run { AppManager.shared.appState = .success }
          EventService.sendEvent(key: EventKeys.userRegisterGoogle)
        }
      }
    }
  }
  
  static func signOut() async {
    GIDSignIn.sharedInstance.signOut()
  }
  
}
