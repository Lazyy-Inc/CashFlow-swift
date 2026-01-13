//
//  LicenseRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI
import DesignSystem

struct LicenseRow: View {
    
    // MARK: -
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .frame(width: 50, height: 50)
                .foregroundStyle(Color.green.opacity(0.3))
                .overlay {
                    Image(systemName: "doc.text.fill")
                        .foregroundStyle(.green)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("setting_credits_licences_title".localized)
                    .font(.Body.large)
                Text("setting_credits_licences_desc".localized)
                    .font(.Body.small, color: .Text.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color.Text.secondary)
        }
        .padding(12)
        .padding(.horizontal, 4)
        .background {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.Background.bg100)
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    LicenseRow()
        .padding()
        .background(Color.Background.bg50)
}
