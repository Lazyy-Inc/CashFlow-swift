//
//  SettingsDebugView.swift
//  CashFlow
//
//  Created by Theo Sementa on 07/12/2024.
//

import SwiftUI
import Navigation
import Core
import Networking

public struct SettingsDebugView: View {
    
    @State private var showOnboarding: Bool = false
    @Environment(Router<AppDestination>.self) private var router
    
    public init() { }
    
    // MARK: -
    public var body: some View {
        Form {
            Section {
                Button {
                    KeychainManager.shared.setItemToKeychain(id: KeychainService.refreshToken.rawValue, data: "")
                } label: {
                    Text("Reset refresh token")
                }
            }
            
            Section {
                Button {
                    showOnboarding.toggle()
                } label: {
                    Text("Show onboarding")
                }
                Button {
                    router.present(route: .sheet(style: .fitContent), .tips(.applePayShortcut))
                } label: {
                    Text("Show tip Apple Pay")
                }
            }
        }
        .navigationTitle("Debug")
        .navigationBarTitleDisplayMode(.inline)
//        .sheet(isPresented: $showOnboarding, content: { OnboardingScreen().interactiveDismissDisabled() })
    } // body
} // struct

// MARK: -
#Preview {
    SettingsDebugView()
}
