//
//  File.swift
//  CoreModule
//
//  Created by Theo Sementa on 19/08/2025.
//

import Foundation
import NavigationKit
import AlertKit

public extension AlertManager {
    
    func showPaywall(router: Router<AppDestination>) {
        self.present(
            title: "alert_cashflow_pro_title".localized,
            message: "alert_cashflow_pro_desc".localized,
            buttonTitle: "alert_cashflow_pro_action_button".localized,
            isDestructive: false,
            action: {
                router.present(route: .fullScreenCover, .shared(.paywall))
            }
        )
    }
    
}
