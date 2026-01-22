//
//  File.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import Foundation
import Models
import SwiftUI
import ToastBannerKit

extension ToastBannerStyle: @retroactive ToastBannerStyleProtocol { }

extension ToastBannerStyle {

    var foregroundColor: Color {
        switch self {
        case .neutral:
            return Color.Text.primaryReversed
        case .error:
            return Color.Red.r500
        case .success:
            return Color.Primary.p500
        }
    }

    var backgroundColor: Color {
        switch self {
        case .neutral:
            return Color.Text.primary
        case .error:
            return Color.Red.r100
        case .success:
            return Color.Primary.p100
        }
    }

}
