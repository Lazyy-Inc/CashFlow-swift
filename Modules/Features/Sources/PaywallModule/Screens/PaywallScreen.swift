//
//  PaywallScreen.swift
//  CashFlow
//
//  Created by Theo Sementa on 20/08/2023.
//
// Localizations 01/10/2023

import SwiftUI
import Core
import DesignSystem
import Events

public struct PaywallScreen: View {
    
    // MARK: Environment
    @EnvironmentObject private var store: PurchasesManager
    
    // MARK: Init
    public init() { }
    
    // MARK: - View
    public var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.large) {
                
                ScrollView {
                    VStack(spacing: Spacing.large) {
                        PaywallHeaderView()
                        
                        PaywallSubscriptionButtonView(style: .cashFlowPlus)
                        
                        PaywallRowView(
                            imageName: "iconSparkles",
                            title: "paywall_ia_title".localized,
                            text: "paywall_ia_desc".localized,
                            color: .Settings.settingsBlue,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconLineChart",
                            title: "paywall_stats_title".localized,
                            text: "paywall_stats_desc".localized,
                            color: .Settings.settingsOrange,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconAppleLogo",
                            title: "paywall_item_applepay_title".localized,
                            text: "paywall_item_applepay_description".localized,
                            color: .Settings.settingsPurple,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconCreditCard",
                            title: "paywall_bank_accounts_title".localized,
                            text: "paywall_bank_accounts_desc_plus".localized,
                            color: .yellow,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconLandmark",
                            title: "paywall_savings_accounts_title".localized,
                            text: "paywall_savings_accounts_desc_plus".localized,
                            color: .Settings.settingsGreen,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconPiggyBank",
                            title: "paywall_savings_plans_title".localized,
                            text: "paywall_savings_plans_desc_plus".localized,
                            color: .Settings.settingsGreen,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconPieChart",
                            title: "paywall_budgets_title".localized,
                            text: "paywall_budgets_desc".localized,
                            color: .Settings.settingsPurple,
                            isDetailed: false
                        )
                        
                        PaywallRowView(
                            imageName: "iconCreditCard",
                            title: "paywall_bank_cards_title".localized,
                            text: "paywall_bank_cards_desc".localized,
                            color: .Settings.settingsOrange,
                            isDetailed: false
                        )
                        
                        //            NavigationLink(destination: {
                        //              PaywallFeatureDetailScreen(
                        //                title: "word_statistics".localized,
                        //                imageWithout: ["stat1WithoutPaywallDetailled", "stat2WithoutPaywallDetailled"],
                        //                imageWith: ["stat1WithPaywallDetailled", "stat2WithPaywallDetailled"],
                        //                desc: "paywall_detailled_statistics".localized
                        //              )
                        //            }, label: {
                        //              PaywallRowView(
                        //                imageName: "chart.xyaxis.line",
                        //                title: "word_statistics".localized,
                        //                text: "paywall_statistics_desc".localized,
                        //                color: .yellow,
                        //                isDetailed: true
                        //              )
                        //            })
                        
                        //            PaywallRowView(
                        //              imageName: "person.fill",
                        //              title: "paywall_support_dev".localized,
                        //              text: "paywall_support_dev_desc".localized,
                        //              color: .blue,
                        //              isDetailed: false
                        //            )
                    }
                }
                .scrollIndicators(.hidden)
                
                VStack(spacing: 8) {
                    PaywallPayementButtonView()
                    
                    AsyncButton { await store.restorePurchases() } label: {
                        Text("paywall_restore".localized)
                            .font(.Body.small, color: .primary500)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 8)
                }
            }
            .padding()
            .background(Color.Background.bg50)
        } // NavigationStack
        .onAppear {
            // EventService.sendEvent(key: EventKeys.appPaywall)
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallScreen()
        .environmentObject(PurchasesManager())
}
