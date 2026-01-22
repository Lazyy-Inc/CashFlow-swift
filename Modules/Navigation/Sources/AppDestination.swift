//
//  AppDestination.swift
//  Core
//
//  Created by Theo Sementa on 09/08/2025.
//

import NavigationKit

public enum AppDestination: AppDestinationProtocol {
    case account(AccountDestination)
    case savingsAccount(SavingsAccountDestination)
    case transfer(TransferDestination)
    case transaction(TransactionDestination)
    case subscription(SubscriptionDestination)
    case savingsPlan(SavingsPlanDestination)
    case contribution(ContributionDestination)
    case budget(BudgetsDestination)
    case creditCard(CreditCardDestination)
    case category(CategoryDestination)
    case subcategory(SubcategoryDestination)
    
    case settings(SettingsDestination)
    case shared(SharedDestination)
    case tips(TipsDestination)
}

extension AppDestination: RecursiveDestination {
    public var unwrapped: AnyHashable {
        switch self {
        case .account(let accountDestination):
            return accountDestination
        case .savingsAccount(let savingsAccountDestination):
            return savingsAccountDestination
        case .transfer(let transferDestination):
            return transferDestination
        case .transaction(let transactionDestination):
            return transactionDestination
        case .subscription(let subscriptionDestination):
            return subscriptionDestination
        case .savingsPlan(let savingsPlanDestination):
            return savingsPlanDestination
        case .contribution(let contributionDestination):
            return contributionDestination
        case .budget(let budgetsDestination):
            return budgetsDestination
        case .creditCard(let creditCardDestination):
            return creditCardDestination
        case .category(let categoryDestination):
            return categoryDestination
        case .subcategory(let subcategoryDestination):
            return subcategoryDestination
        case .settings(let settingsDestination):
            return settingsDestination
        case .shared(let sharedDestination):
            return sharedDestination
        case .tips(let tipsDestination):
            return tipsDestination
        }
    }
}
