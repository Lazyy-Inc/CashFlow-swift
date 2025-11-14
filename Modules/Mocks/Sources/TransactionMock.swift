//
//  TransactionMock.swift
//  CashFlow
//
//  Created by Theo Sementa on 16/11/2024.
//

import Foundation
import Models

public extension TransactionModel {
  
  static let mocks: [TransactionModel] = [
    .mockClassicTransaction,
    .mockClassicTransaction2,
    .mockClassicTransaction3,
    .mockClassicTransaction4,
    .mockTransactionFromSubscription,
    .mockApplePayTransaction,
    .mockTransferTransaction
  ]
  
}

public extension TransactionModel {
  
  static let mockClassicTransaction: TransactionModel = .init(
    id: 1,
    name: "Mock Classic Transaction",
    amount: 20,
    date: Date.now,
    category: CategoryModel.mock,
    subcategory: SubcategoryModel.mock,
    lat: 49.253518498825116,
    long: 6.05911732080831
  )
  
  static let mockTransferTransaction: TransactionModel = .init(
    id: 2,
    name: "",
    amount: 300,
    date: Date.now,
    senderAccount: AccountModel.mockClassicAccount,
    receiverAccount: AccountModel.mockSavingsAccount
  )
  
  static let mockApplePayTransaction: TransactionModel = .init(
    id: 3,
    name: "Culture Pain",
    amount: 6,
    date: Date.now,
    category: CategoryModel.mock,
    subcategory: SubcategoryModel.mock,
    isFromApplePay: true,
    lat: 49.253518498825116,
    long: 6.05911732080831
  )
  
  static let mockTransactionFromSubscription: TransactionModel = .init(
    id: 4,
    name: "Spotify",
    amount: 21,
    date: Date.now,
    isFromSubscription: true
  )
  
  static let mockClassicTransaction2: TransactionModel = .init(
    id: 5,
    name: "Action",
    amount: 27.12,
    date: Date.now,
    category: CategoryModel.mock,
    subcategory: SubcategoryModel.mock,
  )
  
  static let mockClassicTransaction3: TransactionModel = .init(
    id: 6,
    name: "Cedaf SARL",
    amount: 1.2,
    date: Date.now
  )
  
  static let mockClassicTransaction4: TransactionModel = .init(
    id: 7,
    name: "Robot trading",
    amount: 25,
    date: Date.now
  )
  
}
