//
//  SwiftUIView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 15/10/2025.
//

import SwiftUI

public struct StatisticsItem {
    let value: String
    let text: String
    var color: Color?
    
    public init(value: String, text: String, color: Color? = nil) {
        self.value = value
        self.text = text
        self.color = color
    }
}

public struct TwoStatisticsRowView: View {
    
    // MARK: Dependencies
    let leftItem: StatisticsItem
    let rightItem: StatisticsItem
    
    // MARK: States
    @State private var componentHeight: CGFloat = 0
    
    // MARK: Init
    public init(leftItem: StatisticsItem, rightItem: StatisticsItem) {
        self.leftItem = leftItem
        self.rightItem = rightItem
    }
    
    // MARK: - View
    public var body: some View {
        HStack(spacing: Spacing.large) {
            itemRowView(item: leftItem)
            
            Rectangle()
                .fill(Color.Background.bg200)
                .frame(width: 1)
                .frame(maxHeight: .infinity)
            
            itemRowView(item: rightItem)
        }
        .padding(Spacing.large)
        .roundedRectangleBorder(
            Color.Background.bg100,
            radius: CornerRadius.large,
            lineWidth: 1,
            strokeColor: Color.Background.bg200
        )
    }
}

// MARK: - Subviews
extension TwoStatisticsRowView {
    
    @ViewBuilder 
    func itemRowView(item: StatisticsItem) -> some View {
        VStack(spacing: 0) {
            Text(item.value)
                .font(.Title.large)
                .foregroundStyle(item.color ?? Color.label)
                .contentTransition(.numericText())
                .animation(.smooth, value: item.value)
            
            Text(item.text)
                .font(.Body.small)
                .foregroundStyle(Color.Background.bg600)
        }
        .fullWidth()
    }
    
}

// MARK: - Preview
#Preview {
    TwoStatisticsRowView(
        leftItem: .init(value: "+4 234,5 €", text: "Revenus du mois", color: Color.primary500),
        rightItem: .init(value: "-126,8 €", text: "Dépenses du mois", color: Color.red)
    )
    .padding()
    .background(Color.Background.bg50)
}
