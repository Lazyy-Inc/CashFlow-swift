//
//  BetterScrollView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 07/01/2026.
//

import SwiftUI

public struct BetterScrollView<Header: View, Content: View>: View {
    
    public enum HeaderBackground {
        case blur
        case custom(AnyView)
    }
    
    // MARK: Inputs
    let header: Header
    let content: (ScrollViewProxy) -> Content
    private let headerBackground: HeaderBackground
    
    // MARK: State
    @State private var headerHeight: CGFloat = 0
    @State private var alreadyCalculatedHeaderHeight: Bool = false
    @StateObject private var keyboard: KeyboardManager = .init()
    
    // MARK: Config
    private let scrollIndicators: ScrollIndicatorVisibility
    private let scrollBehavior: ScrollDismissesKeyboardMode
    private let maxBlurRadius: CGFloat
    
    // MARK: Init
    public init(
        scrollIndicators: ScrollIndicatorVisibility = .hidden,
        scrollBehavior: ScrollDismissesKeyboardMode = .interactively,
        headerBackground: HeaderBackground = .blur,
        maxBlurRadius: CGFloat = 10,
        @ViewBuilder header: () -> Header,
        @ViewBuilder content: @escaping (ScrollViewProxy) -> Content
    ) {
        self.header = header()
        self.content = content
        self.headerBackground = headerBackground
        self.maxBlurRadius = maxBlurRadius
        self.scrollIndicators = scrollIndicators
        self.scrollBehavior = scrollBehavior
    }
    
    // MARK: Environment
    @Environment(\.safeAreaInsets) private var safeAreaInsets

    // MARK: - View
    public var body: some View {
        ZStack(alignment: .top) {
            ScrollViewReader { proxy in
                ScrollView {
                    Color.clear
                        .frame(height: headerHeight)

                    content(proxy)

                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: keyboard.isKeyboardVisible ? keyboard.keyboardHeight : 0)
                }
                .scrollIndicators(scrollIndicators)
                .scrollDismissesKeyboard(scrollBehavior)
                .edgesIgnoringSafeArea(.bottom)
            }

            header
                .frame(height: headerHeight != 0 ? headerHeight + safeAreaInsets.top : nil, alignment: .bottom)
                .background(headerBackgroundView())
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
    
    @ViewBuilder
    private func headerBackgroundView() -> some View {
        switch headerBackground {
        case .blur:
            VariableBlurView(maxBlurRadius: maxBlurRadius, direction: .blurredTopClearBottom)
        case .custom(let view):
            view
        }
    }
    
}
