//
//  UIImage+Extensions.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import SwiftUI
import Models

public extension UIImage {
    
    convenience init?(asset: ImageType) {
        self.init(named: asset.rawValue, in: .module, with: nil)
    }
    
}
