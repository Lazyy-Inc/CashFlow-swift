//
//  FinancialItemTypePickerView.swift
//  CashFlow
//
//  Created by Theo Sementa on 19/11/2024.
//

import SwiftUI
import Core
import Models

struct FinancialItemTypePickerView: View {
    
    // builder
    @Binding var selected: FinancialItemType
    
    @Environment(\.theme) private var theme
    
    // MARK: -
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(Word.Classic.typeOfTransaction)
                .padding(.leading, 8)
                .font(.system(size: 12, weight: .regular))
            
            HStack(spacing: 0) {
                ForEach([FinancialItemType.expense, FinancialItemType.income], id: \.self) { type in
                    Button {
                        withAnimation { selected = type }
                    } label: {
                        Text(type.name)
                            .lineLimit(1)
                            .foregroundStyle(Color.text)
                    }
                    .padding(.vertical)
                    .frame(maxWidth: .infinity)
                }
            }
            .background {
                GeometryReader { geo in
                    let itemSize = (geo.size.width / 2)
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .foregroundStyle(Color.Background.bg200)
                        .overlay(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .foregroundStyle(theme.color)
                                .frame(width: itemSize)
                                .offset(x: itemSize * CGFloat(selected.rawValue))
                                .animation(.smooth, value: selected)
                        }
                }
            }
        }
    } // body
} // struct

// MARK: - Preview
#Preview {
    FinancialItemTypePickerView(selected: .constant(.expense))
}
