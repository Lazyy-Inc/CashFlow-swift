//
//  CategoryHeaderView.swift
//  CashFlow
//
//  Created by Theo Sementa on 03/12/2024.
//

import SwiftUI
import Core
import Models
import Mocks

public struct CategoryHeaderView: View {
    
    // MARK: Dependencies
    var category: CategoryModel
    
    public init(category: CategoryModel) {
        self.category = category
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: 8) {
            Text(category.name)
                .font(.mediumCustom(size: 22))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Circle()
                .frame(width: 30, height: 30)
                .foregroundStyle(category.color)
                .overlay {
                    IconSVG(icon: category.icon, value: .small)
                        .foregroundStyle(Color.white)
                }
        }
    }
}

// MARK: - Preview
#Preview {
  CategoryHeaderView(category: .mock)
}
