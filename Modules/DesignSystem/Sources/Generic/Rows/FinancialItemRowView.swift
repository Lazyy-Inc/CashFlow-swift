//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 14/11/2025.
//

import SwiftUI
import Models

struct FinancialItemRowView: View {
    
    // MARK: Dependencies
    let financialItem: FinancialItemProtocol
    var isEditable: Bool = true
    
    // MARK: - View
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

// MARK: - Subviews
extension FinancialItemRowView {
    
//    @ViewBuilder
//    private func transactionAmountWithDate(_ transaction: TransactionModel) -> some View {
//        VStack(alignment: .trailing, spacing: Spacing.extraSmall) {
//            Text("\(currentTransaction.symbol) \(financialItem.amount.toCurrency())")
//                .fontWithLineHeight(.Body.mediumBold)
//                .foregroundStyle(financialItem.type.color())
//                .lineLimit(1)
//            
//            Text(financialItem.date.withTemporality)
//                .fontWithLineHeight(.Body.small)
//                .foregroundStyle(Color.Background.bg600)
//                .lineLimit(1)
//        }
//    }
    
}

// MARK: - Preview
#Preview {
    FinancialItemRowView(financialItem: TransactionModel.mockClassicTransaction)
}
