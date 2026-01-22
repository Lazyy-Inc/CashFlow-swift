//
//  ToastUIBannerModel+Extensions.swift
//  DesignSystem
//
//  Created by Theo Sementa on 22/01/2026.
//

import Models
import ToastBannerKit
import UIKit

public extension ToastBannerUIModel {
    
    @MainActor
    static let errorAmountMandatory: ToastBannerUIModel = .init(
        title: "toast_banner_amount_mandatory".localized, // TODO: An amount is mandatory
        uiImage: UIImage(asset: .iconWarning),
        style: ToastBannerStyle.error
    )
    
}

public extension ToastBannerUIModel {
    
    @MainActor
    static let vehicleCreated: ToastBannerUIModel = .init(
        title: "toast_banner_vehicle_created".localized,
        style: ToastBannerStyle.success
    )
    
    @MainActor
    static let mileageUpdated: ToastBannerUIModel = .init(
        title: "toast_banner_mileage_updated".localized,
        style: ToastBannerStyle.success
    )
    
}
