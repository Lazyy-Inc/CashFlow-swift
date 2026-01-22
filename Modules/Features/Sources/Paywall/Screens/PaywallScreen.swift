//
//  SwiftUIView.swift
//  Features
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import DesignSystem
import Navigation

public struct PaywallScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: ViewModel = .init()
    
    @State private var router: Router<AppDestination> = .init()
    
    public init() { }
    
    // MARK: - View
    public var body: some View {
//        NavigationStackView(
//            router: router,
//            destinationContent: { AppDestination.content(for: $0) }
//        ) {
            ScrollView {
                VStack(spacing: .huge) {
                    Button { dismiss() } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundStyle(Color.Base.white)
                            .fullWidth(.trailing)
                    }
                    
                    Text("paywall_header".localized)
                        .font(.Title.large, color: .Base.white)
                        .multilineTextAlignment(.center)
                    
                    VStack(spacing: .large) {
                        ForEach(viewModel.listOfFeatures) { feature in
                            PaywallRowView(item: feature)
                        }
                    }
                    
                    PaywallComparisonSectionView(comparisons: viewModel.comparisons)
                    
                    PaywallLinksView()
                    
                    Color.clear.frame(height: 200)
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.all, .standard, for: .scrollContent)
            .fullSize()
            .background(LinearGradient.main)
            .overlay(alignment: .bottom) {
                PaywallPaymentButtonView()
            }
            .ignoresSafeArea(.all, edges: .bottom)
//        }
    }
    
}

// MARK: - Preview
#Preview {
    PaywallScreen()
}
