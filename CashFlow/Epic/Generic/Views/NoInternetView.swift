//
//  NoInternetView.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/04/2025.
//

import SwiftUI
import DesignSystem
import Core

struct NoInternetView: View {
    
    // MARK: -
    var body: some View {
        VStack(spacing: Spacing.large) {
            Image("NoInternet")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .shadow(radius: 4, y: 4)
                .frame(width: UIScreen.main.bounds.width / (UIDevice.isIpad ? 3 : 1.5))
            
            Text("OOPS...")
                .font(.Title.medium)
            
            Text("no_internet_description".localized)
                .font(.Body.small)
                .multilineTextAlignment(.center)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    NoInternetView()
}
