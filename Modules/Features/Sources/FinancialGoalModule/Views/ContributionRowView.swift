//
//  ContributionRowView.swift
//  CashFlow
//
//  Created by Théo Sementa on 09/07/2023.
//
// Localizations 01/10/2023

import SwiftUI
import AlertKit
import Core
import Models
import DesignSystem

struct ContributionRowView: View {
    
    // Builder
    var savingsPlan: SavingsPlanModel
    var contribution: ContributionModel
    
    var contributionName: String {
        if let name = contribution.name, !name.isEmpty {
            return name
        } else {
            return contribution.type == .withdrawal ? "contribution_cell_withdrawn".localized : "contribution_cell_added".localized
        }
    }
    
    // MARK: -
    var body: some View {
        HStack {
            Text(contributionName)
                .font(.Body.medium)
                .fullWidth(.leading)
            
            VStack(alignment: .trailing, spacing: 3) {
                Text("\(contribution.symbol) \(contribution.amount?.toCurrency() ?? "")")
                    .font(.Body.medium, color: contribution.type == .withdrawal ? Color.Error.error400 : Color.primary500)
                
                Text(contribution.date.formatted(date: .numeric, time: .omitted))
                    .font(.Body.small, color: .customGray)
            }
        }
        .padding(12)
        .padding(.horizontal, 4)
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.standard,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
        .padding(.vertical, 2)
        .contentShape(.contextMenuPreview, .rect(cornerRadius: CornerRadius.standard))
        .contextMenu {
            contextMenuView
        } preview: {
            self
                .frame(width: UIScreen.main.bounds.width - 32)
        }
    } // body
} // struct

// MARK: - Subviews
extension ContributionRowView {
    
    private var contextMenuView: some View {
        Button(role: .destructive) {
            AlertManager.shared.deleteContribution(
                savingsPlan: savingsPlan,
                contribution: contribution
            )
        } label: {
            Label("word_delete".localized, systemImage: "trash")
        }
    }
    
}

// MARK: - Preview
#Preview {
    ContributionRowView(savingsPlan: .mockClassicSavingsPlan, contribution: .mockContribution)
}
