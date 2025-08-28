//
//  BannerManager.swift
//  Essential
//
//  Created by Theo Sementa on 11/03/2024.
//

import Foundation

public class BannerManager: ObservableObject {
    @MainActor public static let shared = BannerManager()
    
    @Published public var banner: Banner?
}
