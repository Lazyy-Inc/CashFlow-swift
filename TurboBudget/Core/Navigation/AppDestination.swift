//
//  AppDestination.swift
//  CashFlow
//
//  Created by Theo Sementa on 17/04/2025.
//

import SwiftUICore
import CoreModule
import NavigationKit
import PaywallModule
import TransactionModule
import SubscriptionModule
import SavingsPlanModule
import ContributionModule
import AccountModule
import BudgetModule

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
    
    static private func destiantionAccount(_ account: AccountDestination) -> some View {
        switch account {
        case .create:
            AnyView(AccountAddScreen(type: .classic))
        case .update(let account):
            AnyView(AccountAddScreen(type: .classic, account: account))
        case .dashboard:
            AnyView(AccountDashboardScreen())
        case .statistics:
            AnyView(AccountStatisticsScreen())
        }
    }
    
    static private func destinationSavingsAccount(_ savingsAccount: SavingsAccountDestination) -> some View {
        switch savingsAccount {
        case .create:
            AnyView(AccountAddScreen(type: .savings))
        case .update(let account):
            AnyView(AccountAddScreen(type: .savings, account: account))
        case .list:
            AnyView(SavingsAccountsListView())
        case .detail(let savingsAccount):
            AnyView(SavingsAccountDetailScreen(savingsAccount: savingsAccount))
        case .createTransaction(let savingsAccount, let transaction):
            AnyView(CreateTransactionForSavingsAccountScreen(savingsAccount: savingsAccount, transaction: transaction))
        }
    }
    
    static private func destinationTransfer(_ transfer: TransferDestination) -> some View {
        switch transfer {
        case .create(let receiverAccount):
            AnyView(TransferAddScreen(receiverAccount: receiverAccount))
        }
    }
    
    static private func destinationTransaction(_ transaction: TransactionDestination) -> some View {
        switch transaction {
        case .list:
            AnyView(TransactionsScreen())
        case .specificList(let month, let type):
            AnyView(TransactionsForMonthScreen(selectedDate: month, type: type))
        case .create:
            AnyView(TransactionAddScreen())
        case .update(let transaction):
            AnyView(TransactionAddScreen(transaction: transaction))
        case .detail(let transaction):
            AnyView(TransactionDetailsScreen(transaction: transaction))
        }
    }
    
    static private func destinationSubscription(_ subscription: SubscriptionDestination) -> some View {
        switch subscription {
        case .list:
            AnyView(SubscriptionsListScreen())
        case .create:
            AnyView(SubscriptionAddScreen())
        case .update(let subscription):
            AnyView(SubscriptionAddScreen(subscription: subscription))
        case .detail(let subscriptionId):
            AnyView(SubscriptionDetailsScreen(subscriptionId: subscriptionId))
        }
    }
    
    static private func destinationSavingsPlan(_ savingsPlan: SavingsPlanDestination) -> some View {
        switch savingsPlan {
        case .list:
            AnyView(SavingsPlanListScreen())
        case .create:
            AnyView(SavingPlansAddScreen())
        case .update(let savingsPlan):
            AnyView(SavingPlansAddScreen(savingsPlan: savingsPlan))
        case .detail(let savingsPlan):
            AnyView(SavingsPlanDetailScreen(savingsPlan: savingsPlan))
        }
    }
    
    static private func destinationContribution(_ contribution: ContributionDestination) -> some View {
        switch contribution {
        case .create(let savingsPlan):
            AnyView(ContributionAddScreen(savingsPlan: savingsPlan))
        }
    }
    
    static private func destinationBudget(_ budget: BudgetsDestination) -> some View {
        switch budget {
        case .list:
            AnyView(BudgetsListScreen())
        case .create:
            AnyView(BudgetAddScreen())
        case .transactions(let subcategory):
            AnyView(BudgetsTransactionsListScreen(subcategory: subcategory))
        }
    }
    
    static private func destinationCreditCard(_ creditCard: CreditCardDestination) -> some View {
        switch creditCard {
        case .create:
            AnyView(CreditCardAddScreen())
        }
    }
    
    static private func destinationCategory(_ category: CategoryDestination) -> some View {
        switch category {
        case .list:
            AnyView(CategoriesListScreen())
        case .transactions(let category, let selectedDate):
            AnyView(CategoryTransactionsScreen(category: category, selectedDate: selectedDate))
        case .select(let selectedCategory, let selectedSubcategory):
            AnyView(SelectCategoryScreen(selectedCategory: selectedCategory, selectedSubcategory: selectedSubcategory))
        }
    }
    
    static private func destinationSubcategory(_ subcategory: SubcategoryDestination) -> some View {
        switch subcategory {
        case .list(let category, let selectedDate):
            AnyView(SubcategoryListScreen(category: category, selectedDate: selectedDate))
        case .transactions(let subcategory, let selectedDate):
            AnyView(SubcategoryTransactionsScreen(subcategory: subcategory, selectedDate: selectedDate))
        }
    }
    
    static private func destinationSettings(_ setting: SettingsDestination) -> some View {
        switch setting {
        case .home:
            AnyView(SettingsScreen())
        case .debug:
            AnyView(SettingsDebugView())
        case .general:
            AnyView(SettingsGeneralView())
        case .security:
            AnyView(SettingsSecurityView())
        case .appearance:
            AnyView(SettingsAppearenceView())
        case .display:
            AnyView(SettingsDisplayView())
        case .account:
            AnyView(SettingsAccountScreen())
        case .subscription:
            AnyView(SettingsSubscriptionScreen())
        case .credits:
            AnyView(SettingsCreditsView())
        case .applePay:
            AnyView(SettingsApplePayView())
        }
    }
    
    static private func destinationShared(_ shared: SharedDestination) -> some View {
        switch shared {
        case .paywall:
            AnyView(PaywallScreen())
        case .whatsNew:
            AnyView(WhatsNewScreen())
        case .qrCodeScanner:
            AnyView(QRCodeScannerScreen())
        case .home:
            AnyView(HomeScreen())
        case .analytics:
            AnyView(AnalyticsScreen())
        case .releaseNoteDetail(let releaseNote):
            AnyView(ReleaseNoteDetailView(releaseNote: releaseNote))
        }
    }
    
    static private func destinationTips(_ tips: TipsDestination) -> some View {
        switch tips {
        case .applePayShortcut:
            AnyView(TipApplePayShortcutScreen())
        }
    }
    
}
