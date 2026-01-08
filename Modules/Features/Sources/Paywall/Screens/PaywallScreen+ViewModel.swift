//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import Foundation
import Models

extension PaywallScreen {
    
    @Observable
    final class ViewModel {
        
        let paywallService: PaywallService
        
        init(paywallService: PaywallService = DefaultPaywallService()) {
            self.paywallService = paywallService
        }
        
    }
    
}

// MARK: - UI Variables
extension PaywallScreen.ViewModel {
    
    var listOfFeatures: [PaywallUIModel] {
        return paywallService.listOfFeatures()
    }
    
    var comparisons: [PaywallComparisonUIModel] {
        return paywallService.listOfComparisons()
    }
    
}
