//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Navigation

public extension NavigationRegistry {
    
    func registerTransferRoutes() {
        self.register(TransferDestination.self) { destination in
            switch destination {
            case .create(let receiverAccount):
                AnyView(AddTransferScreen(receiverAccount: receiverAccount))
            }
        }
    }
    
}
