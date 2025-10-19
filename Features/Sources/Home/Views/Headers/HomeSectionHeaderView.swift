//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 17/10/2025.
//

import SwiftUI
import DesignSystem
import Navigation

struct HomeSectionHeaderView: View {
    
    // MARK: Dependencies
    let title: String
    let destination: AppDestination
    
    // MARK: - View
    var body: some View {
        HStack(spacing: Spacing.extraSmall) {
            Text(title)
                .fontWithLineHeight(.Title.medium)
                .fullWidth(.leading)
            
            NavigationButtonView(
                route: .push,
                destination: destination
            ) {
                Text("home_see_all".localized)
                    .fontWithLineHeight(.Body.small)
                    .foregroundStyle(Color.text)
                    .underline(true)
            }
        }
    }
    
}

// MARK: - Preview
#Preview {
    HomeSectionHeaderView(
        title: "Home header",
        destination: .transaction(.list)
    )
}
