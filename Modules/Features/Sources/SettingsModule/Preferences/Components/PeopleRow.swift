//
//  PeopleRow.swift
//  CashFlow
//
//  Created by Theo Sementa on 04/12/2024.
//

import SwiftUI
import Core

struct PeopleRow: View {
    
    // Builder
    var people: People
        
    // MARK: -
    var body: some View {
        Button(action: {
          URLManager.openURL(url: people.linkedin?.absoluteString ?? "")
        }, label: {
            HStack(spacing: 12) {
                Image(people.image)
                    .resizable()
                    .frame(width: 50, height: 50)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(people.name)
                        .font(.Body.large)
                    Text(people.job)
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
        })
    } // body
} // struct

// MARK: - Preview
#Preview {
    PeopleRow(people: .theoSementa)
        .padding()
        .background(Color.Background.bg50)
}
