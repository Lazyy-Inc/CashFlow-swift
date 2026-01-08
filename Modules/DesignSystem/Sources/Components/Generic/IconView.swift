//
//  IconView.swift
//  DesignSystem
//
//  Created by Theo Sementa on 08/01/2026.
//

import SwiftUI
import Models

public struct IconView: View {

    // MARK: Dependencies
    private let asset: ImageType
    private let renderingMode: Image.TemplateRenderingMode
    private let size: IconSizeType
    private let color: Color

    // MARK: Init
    public init(
        asset: ImageType,
        renderingMode: Image.TemplateRenderingMode = .template,
        size: IconSizeType = .standard,
        color: Color = Color.Base.black
    ) {
        self.asset = asset
        self.renderingMode = renderingMode
        self.size = size
        self.color = color
    }

    // MARK: - View
    public var body: some View {
        Image(asset: asset)
            .resizable()
            .renderingMode(renderingMode)
            .foregroundStyle(color)
            .frame(width: size.rawValue, height: size.rawValue)
    }
}

// MARK: - Preview
#Preview {
    IconView(asset: .iconPieChart)
}
