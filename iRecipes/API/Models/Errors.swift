//
//  Errors.swift
//  iRecipes
//
//  Created by Mihail on 12/22/21.
//

import Foundation

enum ApiError: Error {
    case decodingFailed
    case networkNotAvailable
    case unknown
}

enum NetworkError: Error {
    case serverNotReachable
    case decodingFailed
    case urlConstructionFailed
    case unknown
}

extension ApiError {
    var localizedMessage: String {
        switch self {
        case .decodingFailed:
            return "decodingFailed"
        case .networkNotAvailable:
            return "networkNotAvailable"
        default:
            return "defaultError"
        }
    }
}

