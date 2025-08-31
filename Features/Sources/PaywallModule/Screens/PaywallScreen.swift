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
        PaywallHeaderView()
        
        ScrollView {
          VStack(spacing: 24) {
            NavigationLink(destination: {
              PaywallFeatureDetailScreen(
                title: "paywall_prediction_title".localized,
                imageWithout: [],
                imageWith: ["predictionPaywallDetailled"],
                desc: "paywall_detailled_prediction".localized
              )
              .onAppear { EventService.sendEvent(key: EventKeys.paywallDetailPrediction) }
            }, label: {
              PaywallRowView(
                imageName: "iconSparkles",
                title: "paywall_ia_title".localized,
                text: "paywall_ia_desc".localized,
                color: .blue,
                isDetailed: true
              )
            })
            
            PaywallRowView(
              imageName: "apple.logo",
              title: "paywall_item_applepay_title".localized,
              text: "paywall_item_applepay_description".localized,
              color: .indigo,
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
              color: .green,
              isDetailed: false
            )
            
            PaywallRowView(
              imageName: "iconPiggyBank",
              title: "paywall_savings_plans_title".localized,
              text: "paywall_savings_plans_desc_plus".localized,
              color: .green,
              isDetailed: false
            )
            
            NavigationLink(destination: {
              PaywallFeatureDetailScreen(
                title: "word_budgets".localized,
                imageWithout: [],
                imageWith: ["budgetPaywallDetailled"],
                desc: "paywall_detailled_budgets".localized
              )
              .onAppear { EventService.sendEvent(key: EventKeys.paywallDetailBudgets) }
            }, label: {
              PaywallRowView(
                imageName: "iconPieChart",
                title: "paywall_budgets_title".localized,
                text: "paywall_budgets_desc".localized,
                color: .purple,
                isDetailed: true
              )
            })
            
            PaywallRowView(
              imageName: "iconCreditCard",
              title: "paywall_bank_cards_title".localized,
              text: "paywall_bank_cards_desc".localized,
              color: .orange,
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
          if let lifetime = store.lifetime, !store.isCashFlowPro {
            AsyncButton {
              if let product = store.products.first {
                await store.buyProduct(product)
              }
            } label: {
              let fakePrice = lifetime.price * 2
              PaywallPayementRowView(
                price: lifetime.price.toCurrency(),
                promoText: fakePrice.toCurrency()
              )
            }
          } else {
            Text("paywall_thanks".localized)
              .font(.semiBoldCustom(size: 20))
              .foregroundStyle(.white)
              .frame(maxWidth: .infinity)
              .padding()
              .background(Color.primary500)
              .cornerRadius(15)
          }
          
          AsyncButton { await store.restorePurchases() } label: {
            Text("paywall_restore".localized)
              .font(Font.mediumSmall())
              .foregroundStyle(Color.primary500)
          }
          .frame(maxWidth: .infinity, alignment: .trailing)
          .padding(.trailing, 8)
        }
      }
      .padding()
      .background(Color.Background.bg50)
    } // NavigationStack
    .onAppear {
      EventService.sendEvent(key: EventKeys.appPaywall)
    }
  }
}

// MARK: - Preview
#Preview {
  PaywallScreen()
    .environmentObject(PurchasesManager())
}
