//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import Models
import DesignSystem

struct PaywallRowView: View {
    
    // MARK: Dependencies
    let item: PaywallUIModel
    
    // MARK: - View
    var body: some View {
        HStack(spacing: .medium) {
            IconView(asset: item.icon, color: .Base.white)
                .padding(.small)
            
            VStack(alignment: .leading, spacing: .zero) {
                Text(item.title.localized)
                    .font(.Body.mediumBold, color: .Base.white)
                Text(item.description.localized)
                    .font(.Body.small, color: .Base.white)
            }
            .fullWidth(.leading)
        }
    }
}

// MARK: - Preview
#Preview {
    PaywallRowView(item: .mock)
        .padding()
        .background(Color.green)
}
