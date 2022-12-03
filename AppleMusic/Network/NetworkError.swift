//
//  NetworkError.swift
//  AppleMusic
//
//  Created by Kun Niu on 11/24/22.
//

import Foundation

enum NetworkError : Error{
    case badURL
    case badData
    case decodeFailure(DecodingError)
    case badStatusCode(Int)
    case serverError(Error)
    case other(Error)
}

extension NetworkError : LocalizedError {
    
    var errorDescription: String? {
        switch self {
        case .badURL:
            return NSLocalizedString("url does not exist", comment: "bad url")
        case .badData:
            return NSLocalizedString("empty data", comment: "bad data")
        case .decodeFailure:
            return NSLocalizedString("page does bnot exist or wrong model structure", comment: "decode failure")
        case .badStatusCode(let status):
            return NSLocalizedString("\(status) Error", comment: "bad status code")
        case .serverError(_):
            return NSLocalizedString("somthing is wrong with server", comment: "serer error")
        case .other(_):
            return NSLocalizedString("unknown error, quit using the app", comment: "Unknown error")
        }
    }
    
}
