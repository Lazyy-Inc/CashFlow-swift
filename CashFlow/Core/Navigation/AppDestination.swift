//
//  AppDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUI
import Core
import Navigation
import DesignSystem
import TransactionModule
import SubscriptionModule
import FinancialGoalModule
import ContributionModule
import AccountModule
import BudgetModule
import CategoryModule
import SavingsAccountModule
import TransferModule
import OnboardingModule
import SubcategoryModule
import SettingsModule
import CreditCardModule

import Home
import Paywall

extension AppDestination {
    
    @ViewBuilder
    static func content(for destination: AppDestination) -> some View {
        switch destination {
        case .account(let accountDestination):
            destiantionAccount(accountDestination)
        case .savingsAccount(let savingsAccountDestination):
            destinationSavingsAccount(savingsAccountDestination)
        case .transfer(let transferDestination):
            destinationTransfer(transferDestination)
        case .transaction(let transactionDestination):
            destinationTransaction(transactionDestination)
        case .subscription(let subscriptionDestination):
            destinationSubscription(subscriptionDestination)
        case .savingsPlan(let savingsPlanDestination):
            destinationSavingsPlan(savingsPlanDestination)
        case .contribution(let contributionDestination):
            destinationContribution(contributionDestination)
        case .budget(let budgetsDestination):
            destinationBudget(budgetsDestination)
        case .creditCard(let creditCardDestination):
            destinationCreditCard(creditCardDestination)
        case .category(let categoryDestination):
            destinationCategory(categoryDestination)
        case .subcategory(let subcategoryDestination):
            destinationSubcategory(subcategoryDestination)
        case .settings(let settingsDestination):
            destinationSettings(settingsDestination)
        case .shared(let sharedDestination):
            destinationShared(sharedDestination)
        case .tips(let tipsDestination):
            destinationTips(tipsDestination)
        }
    }
    
    @ViewBuilder
    static private func destiantionAccount(_ account: AccountDestination) -> some View {
        switch account {
        case .create:
            AddAccountScreen(type: .classic)
        case .update(let account):
            AddAccountScreen(type: .classic, account: account)
        case .dashboard:
            EmptyView()
        case .statistics:
            AccountStatisticsScreen()
        }
    }
    
    @ViewBuilder
    static private func destinationSavingsAccount(_ savingsAccount: SavingsAccountDestination) -> some View {
        switch savingsAccount {
        case .create:
            AddAccountScreen(type: .savings)
        case .update(let account):
            AddAccountScreen(type: .savings, account: account)
        case .list:
            SavingsAccountsListView()
        case .detail:
            SavingsAccountDetailScreen()
        case .createTransaction(let savingsAccount, let transaction):
            CreateTransactionForSavingsAccountScreen(savingsAccount: savingsAccount, transaction: transaction)
        }
    }
    
    @ViewBuilder
    static private func destinationTransfer(_ transfer: TransferDestination) -> some View {
        switch transfer {
        case .create(let receiverAccount):
            AddTransferScreen(receiverAccount: receiverAccount)
        }
    }
    
    @ViewBuilder
    static private func destinationTransaction(_ transaction: TransactionDestination) -> some View {
        switch transaction {
        case .list:
            TransactionsScreen()
        case .specificList(let month, let type):
            TransactionsForMonthScreen(selectedDate: month, type: type)
        case .create:
            AddTransactionScreen()
        case .update(let transaction):
            AddTransactionScreen(transaction: transaction)
        case .detail(let transactionId):
            TransactionDetailsScreen(transactionId: transactionId)
        }
    }
    
    @ViewBuilder
    static private func destinationSubscription(_ subscription: SubscriptionDestination) -> some View {
        switch subscription {
        case .list:
            SubscriptionsListScreen()
        case .create:
            AddSubscriptionScreen()
        case .update(let subscription):
            AddSubscriptionScreen(subscription: subscription)
        case .detail(let subscriptionId):
            SubscriptionDetailsScreen(subscriptionId: subscriptionId)
        }
    }
    
    @ViewBuilder
    static private func destinationSavingsPlan(_ savingsPlan: SavingsPlanDestination) -> some View {
        switch savingsPlan {
        case .list:
            SavingsPlanListScreen()
        case .create:
            AddFinancialGoalScreen()
        case .update(let savingsPlan):
            AddFinancialGoalScreen(savingsPlan: savingsPlan)
        case .detail(let savingsPlan):
            FinancialGoalDetailsScreen(savingsPlan: savingsPlan)
        }
    }
    
    @ViewBuilder
    static private func destinationContribution(_ contribution: ContributionDestination) -> some View {
        switch contribution {
        case .create(let savingsPlan):
            AddContributionScreen(savingsPlan: savingsPlan)
        }
    }
    
    @ViewBuilder
    static private func destinationBudget(_ budget: BudgetsDestination) -> some View {
        switch budget {
        case .list:
            BudgetsListScreen()
        case .create:
            BudgetAddScreen()
        case .transactions(let subcategory):
            BudgetsTransactionsListScreen(subcategory: subcategory)
        }
    }
    
    @ViewBuilder
    static private func destinationCreditCard(_ creditCard: CreditCardDestination) -> some View {
        switch creditCard {
        case .create:
            CreditCardAddScreen()
        }
    }
    
    @ViewBuilder
    static private func destinationCategory(_ category: CategoryDestination) -> some View {
        switch category {
        case .list:
            CategoriesListScreen()
        case .transactions(let category, let selectedDate):
            CategoryTransactionsScreen(category: category, selectedDate: selectedDate)
        case .select(let selectedCategory, let selectedSubcategory):
            SelectCategoryScreen(selectedCategory: selectedCategory, selectedSubcategory: selectedSubcategory)
        }
    }
    
    @ViewBuilder
    static private func destinationSubcategory(_ subcategory: SubcategoryDestination) -> some View {
        switch subcategory {
        case .list(let category, let selectedDate):
            SubcategoryListScreen(category: category, selectedDate: selectedDate)
        case .transactions(let subcategory, let selectedDate):
            SubcategoryTransactionsScreen(subcategory: subcategory, selectedDate: selectedDate)
        }
    }
    
    @ViewBuilder
    static private func destinationSettings(_ setting: SettingsDestination) -> some View {
        switch setting {
        case .home:
            SettingsScreen()
        case .debug:
            SettingsDebugView()
        case .general:
            SettingsGeneralView()
        case .security:
            SettingsSecurityView()
        case .appearance:
            SettingsAppearenceView()
        case .display:
            SettingsDisplayView()
        case .account:
            SettingsAccountScreen()
        case .subscription:
            SettingsSubscriptionScreen()
        case .statistics:
            SettingsStatisticsScreen()
        case .credits:
            SettingsCreditsView()
        case .applePay:
            SettingsApplePayView()
        }
    }
    
    @ViewBuilder
    static private func destinationShared(_ shared: SharedDestination) -> some View { // TODO: With registery
        switch shared {
        case .sfSafari(let url):
            SFSafariScreen(url: url)
        case .paywall:
            PaywallScreen()
        case .whatsNew:
            WhatsNewScreen()
        case .qrCodeScanner:
            QRCodeScannerScreen()
        case .home:
            HomeScreen()
        case .releaseNoteDetail(let releaseNote):
            ReleaseNoteDetailView(releaseNote: releaseNote)
        }
    }
    
    @ViewBuilder
    static private func destinationTips(_ tips: TipsDestination) -> some View { // TODO: With registery
        switch tips {
        case .applePayShortcut:
            TipApplePayShortcutScreen()
        }
    }
    
}
