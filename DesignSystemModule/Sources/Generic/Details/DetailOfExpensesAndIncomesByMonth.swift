//
//  DetailOfExpensesAndIncomesByMonth.swift
//  CashFlow
//
//  Created by KaayZenn on 25/09/2023.
//
// Localizations 01/10/2023

import SwiftUI
import CoreModule

public struct DetailOfExpensesAndIncomesByMonth: View {
    
    // Builder
    var month: Date
    var amountOfExpenses: Double
    var amountOfIncomes: Double
    var isPinned: Bool = false

    // Environnement
    @EnvironmentObject var store: PurchasesManager
    
    public init(
        month: Date,
        amountOfExpenses: Double,
        amountOfIncomes: Double,
        isPinned: Bool = false
    ) {
        self.month = month
        self.amountOfExpenses = amountOfExpenses
        self.amountOfIncomes = amountOfIncomes
        self.isPinned = isPinned
    }

    // MARK: - Body
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(month.formatted(.monthAndYear).capitalized)
                    .font(.mediumCustom(size: 22))
                    .foregroundStyle(Color.text)
                
                if store.isCashFlowPro {
                    HStack {
                        if amountOfExpenses != 0 {
                            Text("word_expenses".localized + " : " + amountOfExpenses.toCurrency())
                                .lineLimit(1)
                        }
                        if amountOfExpenses != 0 && amountOfIncomes != 0 {
                            Text("|")
                        }
                        if amountOfIncomes != 0 {
                            Text("word_incomes".localized + " : " + amountOfIncomes.toCurrency())
                                .lineLimit(1)
                        }
                        Spacer()
                    }
                    .foregroundStyle(Color.customGray)
                    .font(.semiBoldSmall())
                }
            }
            Spacer()
        }
        .padding(.vertical, 8)
        .background {
            if isPinned {
                Rectangle().fill(Material.regular)
            } else {
                Color.clear
            }
        }
        .compositingGroup()
    } // body
} // struct

// MARK: - Preview
#Preview {
    DetailOfExpensesAndIncomesByMonth(
        month: .now,
        amountOfExpenses: 200,
        amountOfIncomes: 10
    )
}
