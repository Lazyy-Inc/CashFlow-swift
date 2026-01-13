//
//  SavingsAccountRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import DesignSystem
import Core
import Models

public struct SavingsAccountRowView: View {
    
    // Builder
    var savingsAccount: AccountModel
    
    let width = UIDevice.isIpad ? UIScreen.main.bounds.width / 4 - 16 : UIScreen.main.bounds.width / 2 - 16
    
    public init(savingsAccount: AccountModel) {
        self.savingsAccount = savingsAccount
    }
    
    // MARK: -
    public var body: some View {
        VStack(alignment: .center) {
            HStack {
                Rectangle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(Color.Background.bg200)
                    .clipShape(RoundedRectangle(cornerRadius: CornerRadius.small, style: .continuous))
                    .overlay {
                        Image("iconLandmark")
                            .renderingMode(.template)
                            .foregroundStyle(Color.Text.primary)
                    }
                
                Spacer()
                
                Image("iconArrowRight")
                    .renderingMode(.template)
                    .foregroundStyle(Color.Background.bg600)
            }
            
            Text(savingsAccount.balance.toCurrency())
                .font(.Title.large)
                .lineLimit(1)
                .frame(maxHeight: .infinity)
                .foregroundStyle(Color.Text.primary)
            
            Text(savingsAccount.name)
                .font(.Body.medium)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .foregroundStyle(Color.Text.primary)
        }
        .padding(Padding.standard)
        .aspectRatio(1, contentMode: .fit)
        .roundedBackground(.classic)
    } // body
} // struct

// MARK: - Preview
#Preview {
    SavingsAccountRowView(savingsAccount: .mockSavingsAccount)
}
