//
//  ListWithBluredHeader.swift
//  DesignSystem
//
//  Created by Theo Sementa on 07/01/2026.
//

import SwiftUI

public struct ListWithBluredHeader<Header: View, Content: View>: View {

    // MARK: Dependencies
    let header: Header
    let content: Content
    
    // MARK: State
    @State private var headerHeight: CGFloat = 0
    @State private var alreadyCalculatedHeaderHeight: Bool = false
    
    // MARK: Config
    private let scrollIndicators: ScrollIndicatorVisibility
    private let scrollBehavior: ScrollDismissesKeyboardMode
    private let maxBlurRadius: CGFloat
    
    // MARK: Environment
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    // MARK: init
    public init(
        maxBlurRadius: CGFloat = 10,
        scrollIndicators: ScrollIndicatorVisibility = .hidden,
        scrollBehavior: ScrollDismissesKeyboardMode = .interactively,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: () -> Content
    ) {
        self.maxBlurRadius = maxBlurRadius
        self.scrollIndicators = scrollIndicators
        self.scrollBehavior = scrollBehavior
        self.header = header()
        self.content = content()
    }
    
    // MARK: - View
    public var body: some View {
        ZStack(alignment: .top) {
            List {
                Color.clear
                    .noDefaultStyle()
                    .frame(height: headerHeight)
                
                content
            }
            .listStyle(.plain)
            .scrollIndicators(scrollIndicators)
            .scrollDismissesKeyboard(scrollBehavior)
                        
            header
                .frame(height: headerHeight != 0 ? headerHeight + safeAreaInsets.top : nil, alignment: .bottom)
                .background(VariableBlurView(maxBlurRadius: maxBlurRadius, direction: .blurredTopClearBottom))
                .getSize { size in
                    if !alreadyCalculatedHeaderHeight {
                        self.headerHeight = size.height
                        self.alreadyCalculatedHeaderHeight = true
                    }
                }
                .ignoresSafeArea(edges: .top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
