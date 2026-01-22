//
//  SettingsRowView.swift
//  CashFlow
//
//  Created by Theo Sementa on 15/05/2025.
//

import SwiftUI
import Navigation
import AlertKit
import DesignSystem
import Core

struct SettingsRowView: View {
    
    // MARK: Dependencies
    var item: SettingItemModel
    
    // MARK: Environment
    @EnvironmentObject private var alertManager: AlertManager
    @Environment(Router<AppDestination>.self) private var router
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - View
    var body: some View {
        HStack(spacing: Spacing.medium) {
            Image(item.icon)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(Color.white)
                .frame(width: 16, height: 16)
                .padding(Padding.small)
                .roundedRectangleBorder(
                    item.color,
                    radius: CornerRadius.small
                )
            
            Text(item.title)
                .font(.Body.medium)
                .foregroundStyle(Color.Text.primary)
                .fullWidth(.leading)
            
            Image(item.isPush == true ? "iconArrowRight" : "iconArrowUpRight")
                .renderingMode(.template)
                .foregroundStyle(Color.Background.bg600)
                
        }
        .padding(Padding.medium)
        .roundedBackground(.classic)
        .onTapGesture {
            item.action(router: router, alertManager: alertManager, dismiss: dismiss)
        }
    }
}

// MARK: - Preview
#Preview {
    SettingsRowView(item: .appearance)
}
