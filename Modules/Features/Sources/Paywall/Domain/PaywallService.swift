//
//  File.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import Foundation
import Models

protocol PaywallService {
    func listOfFeatures() -> [PaywallUIModel]
    func listOfComparisons() -> [PaywallComparisonUIModel]
}

final class DefaultPaywallService: PaywallService {
    
    func listOfFeatures() -> [PaywallUIModel] { // TODO: TBL
        
        let budgetFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconPieChart,
            title: "paywall_budget_title",
            description: "paywall_budget_description"
        )
        
        let applePayFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconCreditCard,
            title: "paywall_apple_pay_title",
            description: "paywall_apple_pay_description"
        )
        
        let monthlyReportFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconFileText,
            title: "paywall_monthly_report_title",
            description: "paywall_monthly_report_description"
        )
        
        let advancedAnalyticsFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconLineChart,
            title: "paywall_advanced_analytics_title",
            description: "paywall_advanced_analytics_description"
        )
        
        let reminderFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconBell,
            title: "paywall_reminder_title",
            description: "paywall_reminder_description"
        )
        
        let illimitedBankAccountFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconCreditCard,
            title: "paywall_illimited_bank_account_title",
            description: "paywall_illimited_bank_account_description"
        )
        
        let illimitedFinancialGoalsFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconPiggyBank,
            title: "paywall_illimited_financial_goals_title",
            description: "paywall_illimited_financial_goals_description"
        )
        
        let illimitedSavingsAccountFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconLandmark,
            title: "paywall_illimited_savings_account_title",
            description: "paywall_illimited_savings_account_description"
        )
        
        let saveMoneyFeature: PaywallUIModel = PaywallUIModel(
            icon: .iconBanknote,
            title: "paywall_save_money_title",
            description: "paywall_save_money_description"
        )
        
        return [
            budgetFeature,
            applePayFeature,
            monthlyReportFeature,
            advancedAnalyticsFeature,
            reminderFeature,
            illimitedBankAccountFeature,
            illimitedFinancialGoalsFeature,
            illimitedSavingsAccountFeature,
            saveMoneyFeature
        ]
    }
    
    func listOfComparisons() -> [PaywallComparisonUIModel] { // TODO: TBL
        
        let illimitedBankAccount: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_illimited_bank_account_title",
            free: 1,
            max: 0
        )
        
        let illimitedSavingsAccount: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_illimited_savings_account_title",
            free: 1,
            max: 0
        )
        
        let illimitedFinancialGoal: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_illimited_financial_goals_title",
            free: 2,
            max: 0
        )
        
        let reminder: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_reminder_title",
            free: 0,
            max: 0
        )
        
        let applePay: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_apple_pay_title",
            free: 0,
            max: 0
        )
        
        let saveMoney: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_save_money_title",
            free: 0,
            max: 0
        )
        
        let budget: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_budget_title",
            free: nil,
            max: 0
        )
        
        let monthlyReport: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_monthly_report_title",
            free: nil,
            max: 0
        )
        
        let advancedAnalytics: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_advanced_analytics_title",
            free: nil,
            max: 0
        )
        
        let supportDeveloper: PaywallComparisonUIModel = PaywallComparisonUIModel(
            title: "paywall_support_developer_title",
            free: nil,
            max: 0
        )
        
        return [
            illimitedBankAccount,
            illimitedSavingsAccount,
            illimitedFinancialGoal,
            reminder,
            applePay,
            saveMoney,
            budget,
            monthlyReport,
            advancedAnalytics,
            supportDeveloper
        ]
    }
    
}
