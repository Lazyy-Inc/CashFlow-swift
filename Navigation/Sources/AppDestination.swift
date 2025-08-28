//
//  AppDestination.swift
//  CoreModule
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
