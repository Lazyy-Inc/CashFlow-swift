//
//  PageControllerViewModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 27/10/2023.
//

import Foundation
import SwiftUI
import LocalAuthentication
import Stores
import Preferences

extension RootScreen {
    
    @Observable
    final class ViewModel {
        
        @ObservationIgnored
        @Dependency(\.accountStore) private var accountStore
        
        var showOnboarding: Bool = false
        var isUnlocked: Bool = false
        var launchScreenEnd: Bool = false
        
        private let preferencesGeneral: PreferencesGeneral = .shared
        private let preferencesSecurity: PreferencesSecurity = .shared
    }
    
}

extension RootScreen.ViewModel {
    
    func launchApp(newValue: Bool) {
        if accountStore.selectedAccount != nil && !preferencesGeneral.isAlreadyOpen {
            showOnboarding = false
            preferencesGeneral.isAlreadyOpen = true
        } else if !preferencesGeneral.isAlreadyOpen {
            showOnboarding = true
        }
        
        // LaunchScreen ended
        if newValue {
            // Already open + app close
            if !UserDefaults.standard.bool(forKey: "appIsOpen") && preferencesGeneral.isAlreadyOpen {
                if preferencesSecurity.isBiometricEnabled {
                    authenticate()
                } else {
                    withAnimation { isUnlocked = true }
                    UserDefaults.standard.set(true, forKey: "appIsOpen")
                }
            } else {
                withAnimation { isUnlocked = true }
                UserDefaults.standard.set(true, forKey: "appIsOpen")
            }
        }
    }
    
}

extension RootScreen.ViewModel {
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
         
        // check whether biometric authentication is possible
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // it's possible, so go ahead and use it
            let reason = "alert_request_biometric".localized
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { isAllowed, _ in
                self.isUnlocked = isAllowed
                UserDefaults.standard.set(isAllowed, forKey: "appIsOpen")
            }
        } else { }
    }
    
}
