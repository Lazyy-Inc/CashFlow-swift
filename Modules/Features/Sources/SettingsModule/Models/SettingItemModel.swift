//
//  SettingModel.swift
//  CashFlow
//
//  Created by Theo Sementa on 11/05/2025.
//

import Foundation
import SwiftUI
import Navigation
import AlertKit
import Core
import DesignSystem

enum SettingItemModel: Identifiable {
    case cashFlowPro
    
    case general
    case security
    
    case appearance
    case display
    
    case account
    case subscription
    case statistics
    case applePay
    
    case shortcutApplePay
    case faq
    
    case writeReview
    case reportBug
    case suggestFeature
    case shareApp
    case credits
    case moreOfThisDeveloper
    
    case logout
    case deleteAccount
    
    case conditionsOfUse
    case confidentialityPolicy
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .cashFlowPro: return "setting_home_cashflow_pro".localized
        case .general:     return Word.Title.Setting.general
        case .security:    return Word.Title.Setting.security
        case .appearance:  return "setting_home_appearance".localized
        case .display:     return Word.Title.Setting.display
        case .account:     return "word_account".localized
        case .subscription: return Word.Main.subscription
        case .statistics:  return "settings_statistics_title".localized
        case .applePay:    return "Apple Pay"
        case .shortcutApplePay: return "settings_applepay_shortcut_button".localized
        case .faq:         return "F.A.Q"
        case .writeReview: return "setting_home_write_review".localized
        case .reportBug:   return "setting_home_report_bug".localized
        case .suggestFeature: return "setting_home_new_features".localized
        case .shareApp:    return "setting_home_share_app".localized
        case .credits:     return Word.Title.Setting.credits
        case .moreOfThisDeveloper: return "setting_home_more_from_dev".localized
        case .logout:      return Word.Classic.disconnect
        case .deleteAccount: return Word.Classic.deleteAccount
        case .conditionsOfUse: return "setting_home_terms_conditions".localized
        case .confidentialityPolicy: return "setting_home_privacy_policy".localized
        }
    }
    
    var icon: String {
        switch self {
        case .cashFlowPro:  return "iconCrown"
        case .general:      return "iconGear"
        case .security:     return "iconDoorLocked"
        case .appearance:   return "iconSun"
        case .display:      return "iconSmartphone"
        case .account:      return "iconPerson"
        case .subscription: return "iconClockRepeat"
        case .statistics:   return "iconLineChart"
        case .applePay:     return "iconCreditCard"
        case .shortcutApplePay: return "iconCreditCard"
        case .faq:          return "iconQuestionFile"
        case .writeReview:  return "iconStar"
        case .reportBug:    return "iconAlert"
        case .suggestFeature: return "iconSparkles"
        case .shareApp:     return "iconShare"
        case .credits:      return "iconUserround"
        case .moreOfThisDeveloper: return "iconPerson"
        case .logout:       return "iconLogout"
        case .deleteAccount: return "iconTrash"
        case .conditionsOfUse: return "iconHand"
        case .confidentialityPolicy: return "iconFileLock"
        }
    }
    
    var color: Color {
        switch self {
        case .cashFlowPro: return Color.Primary.p500
        case .general:     return Color.Settings.gray
        case .security:    return Color.Settings.green
        case .appearance:  return Color.Settings.darkPurple
        case .display:     return Color.Settings.blue
        case .account:     return Color.Primary.p500
        case .subscription: return Color.Settings.red
        case .statistics:  return Color.Settings.orange
        case .applePay:    return Color.Settings.purple
        case .shortcutApplePay: return Color.Settings.purple
        case .faq:         return Color.Settings.green
        case .writeReview: return Color.Settings.orange
        case .reportBug:   return Color.Settings.red
        case .suggestFeature: return Color.Settings.purple
        case .shareApp:    return Color.Settings.blue
        case .credits:     return Color.Settings.turquoise
        case .moreOfThisDeveloper: return Color.Settings.green
        case .logout:      return Color.Settings.red
        case .deleteAccount: return Color.Settings.red
        case .conditionsOfUse: return Color.Settings.darkBlue
        case .confidentialityPolicy: return Color.Settings.darkBlue
        }
    }
    
    var isPush: Bool? {
        switch self {
        case .cashFlowPro: return false
        case .general:     return true
        case .security:    return true
        case .appearance:  return true
        case .display:     return true
        case .account:     return true
        case .subscription: return true
        case .statistics:  return true
        case .applePay:    return true
        case .shortcutApplePay: return false
        case .faq:         return false
        case .writeReview: return false
        case .reportBug:   return false
        case .suggestFeature: return false
        case .shareApp:    return false
        case .credits:     return true
        case .moreOfThisDeveloper: return false
        case .logout:      return false
        case .deleteAccount: return false
        case .conditionsOfUse: return false
        case .confidentialityPolicy: return false
        }
    }
    
    // swiftlint:disable:next cyclomatic_complexity
    @MainActor func action(
        router: Router<AppDestination>,
        alertManager: AlertManager? = nil,
        dismiss: DismissAction? = nil
    ) {
        switch self {
        case .cashFlowPro: router.present(route: .fullScreenCover, .shared(.paywall))
        case .general:     router.push(.settings(.general))
        case .security:    router.push(.settings(.security))
        case .appearance:  router.push(.settings(.appearance))
        case .display:     router.push(.settings(.display))
        case .account:     router.push(.settings(.account))
        case .subscription: router.push(.settings(.subscription))
        case .statistics:  router.push(.settings(.statistics))
        case .applePay:    router.push(.settings(.applePay))
        case .shortcutApplePay:
            URLManager.openURL(url: URLManager.PredefinedURL.Tutos.importFromApplePay.rawValue)
        case .faq:
            break
        case .writeReview: URLManager.Setting.writeReview()
        case .reportBug: URLManager.Setting.reportBug()
        case .suggestFeature: URLManager.Setting.suggestFeature()
        case .shareApp:
            break
        case .credits: router.push(.settings(.credits))
        case .moreOfThisDeveloper: URLManager.Setting.showDeveloperAccount()
        case .logout:
            if let alertManager, let dismiss {
                alertManager.signOut(dismiss: dismiss)
            }
        case .deleteAccount:
            if let alertManager, let dismiss {
                alertManager.deleteUser(dismiss: dismiss)
            }
        case .conditionsOfUse:
            URLManager.Setting.showTermsAndConditions()
        case .confidentialityPolicy:
            break
        }
    }
}
