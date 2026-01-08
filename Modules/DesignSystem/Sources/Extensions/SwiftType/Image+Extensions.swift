//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import Models

public extension Image {

    init(asset: ImageType) {
        self.init(asset.rawValue, bundle: .module)
    }
    
    static var logoCashFlow: Image {
        return Image("LogoWalletCashFlow", bundle: BundleHelper.bundle)
    }
    
    struct Onboarding {
        
        public static var illustrationOne: Image {
            return Image("onboardingPage1", bundle: BundleHelper.bundle)
        }
        
        public static var illustrationTwo: Image {
            return Image("onboardingPage2", bundle: BundleHelper.bundle)
        }
        
        public static var illustrationThree: Image {
            return Image("onboardingPage3", bundle: BundleHelper.bundle)
        }
        
    }
    
    struct Brand {
        
        public static var apple: Image {
            return Image("AppleLogo", bundle: BundleHelper.bundle)
        }
        
        public static var google: Image {
            return Image("GoogleLogo", bundle: BundleHelper.bundle)
        }
        
    }

}
