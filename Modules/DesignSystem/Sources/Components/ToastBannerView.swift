//
//  ToastBannerView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Models
import ToastBannerKit

public struct ToastBannerView: View {

    // MARK: Dependencies
    let banner: ToastBannerUIModel

    // MARK: Init
    public init(banner: ToastBannerUIModel) {
        self.banner = banner
    }
    
    // MARK: Computed variables
    var style: ToastBannerStyle {
        return ToastBannerStyle(rawValue: banner.style.rawValue) ?? .error
    }

    // MARK: -
    public var body: some View {
        HStack(spacing: .small) {
            if let uiImage = banner.uiImage {
                Image(uiImage: uiImage)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(style.foregroundColor)
                    .frame(width: .standard, height: .standard)
            }
            
            Text(banner.title)
                .font(.Body.small, color: style.foregroundColor)
                .lineLimit(1)
        }
        .padding(.small)
        .roundedBackground(.custom(color: style.backgroundColor, radius: .small))
    }
}

// MARK: - Preview
#Preview {
    VStack(spacing: .large) {
        ToastBannerView(banner: .errorAmountMandatory)
    }
}
