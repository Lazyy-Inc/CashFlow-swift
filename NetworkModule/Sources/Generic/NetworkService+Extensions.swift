//
//  NetworkService.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import NetworkKit
import Banners

public extension NetworkService {
    
    static func handleError(error: Error) async {
        await MainActor.run {
            if let error = error as? NetworkError {
                BannerManager.shared.banner = error.banner
            }
        }
    }
    
}
