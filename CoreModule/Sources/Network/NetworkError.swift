//
//  NetworkError.swift
//  LifeFlow
//
//  Created by Theo Sementa on 09/03/2024.
//

import Foundation
import NetworkKit

extension NetworkError {
    
    public var banner: Banner {
        switch self {
        case .notFound:                 return Banner.NetworkError.notFoundError
        case .unauthorized:             return Banner.NetworkError.unauthorizedError
        case .badRequest:               return Banner.NetworkError.badRequestError
        case .parsingError:             return Banner.NetworkError.parsingError
        case .fieldIsIncorrectlyFilled: return Banner.NetworkError.fieldIsIncorrectlyFilledError
        case .internalError:            return Banner.NetworkError.internalError
        case .refreshTokenFailed:       return Banner.NetworkError.refreshTokenFailedError
        case .noConnection:             return Banner.NetworkError.noConnectionError
        case .unknown:                  return Banner.NetworkError.unknownError
        case .conflict:                 return Banner.NetworkError.unknownError
        case .noInternet:               return Banner.NetworkError.noConnectionError
        case .upgradeRequired:          return Banner.NetworkError.unknownError
        case .timeout:                  return Banner.NetworkError.unknownError
        case .custom(let message):      return Banner(title: message.localized, style: .error)
        }
    }
    
}
