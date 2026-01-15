//
//  AnalysisScreen+ViewModel.swift
//  Features
//
//  Created by Theo Sementa on 03/09/2025.
//

import Foundation
import Models
import DesignSystem
import SwiftUI
import DataSources

// MARK: - Stored variables
extension AnalysisScreen {
    
    @Observable
    final class ViewModel {
        var selectedDate: Date = Date()
        
        var selectedYear: Int = Date().year
        var amount: Double = 0
        
        // MARK: Constants
        private let transactionDataSource: TransactionDataSource
        
        // MARK: Init
        init(transactionDataSource: TransactionDataSource = DefaultTransactionDataSource.shared) {
            self.transactionDataSource = transactionDataSource
        }
        
    }
    
}

// MARK: - Computed variables
extension AnalysisScreen.ViewModel {
    
    private var transactions: [TransactionModel] {
        return transactionDataSource.transactions(for: .type(.expense, month: selectedDate))
    }
    
    var expensesOfTheMonth: Double {
        return transactions
            .reduce(0) { $0 + $1.amount }
    }
    
    var slices: [PieSliceData] {
        let neededSlice = PieSliceData(
            title: RepartitionType.needed.name,
            value: neededAmount,
            color: Color.Category.categoryHealth
        )
        
        let wantedSlice = PieSliceData(
            title: RepartitionType.wanted.name,
            value: wantedAmount,
            color: Color.Category.categoryLeisure
        )
        
        let savedSlice = PieSliceData(
            title: RepartitionType.saved.name,
            value: savedAmount,
            color: Color.Category.categorySavings
        )
        
        return [neededSlice, wantedSlice, savedSlice]
    }
    
    var neededTransactions: [TransactionModel] {
        return transactions
            .filter { $0.repartitionType == .needed }
    }
    
    var wantedTransactions: [TransactionModel] {
        return transactions
            .filter { $0.repartitionType == .wanted }
    }
    
    var savedTransactions: [TransactionModel] {
        return transactions
            .filter { $0.repartitionType == .saved }
    }
    
    var neededAmount: Double {
        return neededTransactions
            .reduce(0) { $0 + $1.amount }
    }
    
    var wantedAmount: Double {
        return wantedTransactions
            .reduce(0) { $0 + $1.amount }
    }
    
    var savedAmount: Double {
        return savedTransactions
            .reduce(0) { $0 + $1.amount }
    }
    
}

// MARK: - Public functions
extension AnalysisScreen.ViewModel {
    
    func fetchTransactions(for date: Date) async {
        //    let transactionStore: TransactionStore = .shared
        //    let accountStore: AccountStore = .shared
        //
        //    guard let accountId = accountStore.selectedAccount?._id else { return }
        //    guard let startOfMonth = date.startOfMonth, let endOfMonth = date.endOfMonth else { return }
        //
        //    await transactionStore.fetchTransactionsByPeriod(
        //      accountID: accountId,
        //      startDate: startOfMonth,
        //      endDate: endOfMonth,
        //      type: .expense
        //    )
    }
    
}
