//
//  EmptyCategoryData.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import Core
import Stores

public struct EmptyCategoryData: View {
    
    @Environment(\.theme) private var theme
    
    public init() {}
    
    // MARK: -
    public var body: some View {
        VStack(spacing: 16) {
            Image("NoSpend\(theme.nameNotLocalized)")
                .resizable()
                .scaledToFit()
                .padding(.horizontal, 64)
            
            Text("error_message_no_data_month".localized)
                .font(Font.mediumText16())
                .multilineTextAlignment(.center)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    EmptyCategoryData()
        .padding()
}
