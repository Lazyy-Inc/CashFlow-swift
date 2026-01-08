//
//  PageControlView.swift
//  CashFlow
//
//  Created by Theo Sementa on 25/07/2023.
//

import SwiftUI
import Core

public struct PageControl: View {
    
    // Builder
    var maxPages: Int
    var currentPage: Int
    
    @Environment(\.theme) private var theme
    
    public init(maxPages: Int, currentPage: Int) {
        self.maxPages = maxPages
        self.currentPage = currentPage
    }
    
    // MARK: -
    public var body: some View {
        HStack(spacing: 6) {
            ForEach(0...(min(1, maxPages)), id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundStyle(index == currentPage ? theme.color : Color.Background.bg100)
            }
        }
    }
}
