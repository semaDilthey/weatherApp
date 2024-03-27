//
//  NetworkError.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation

enum NetworkError : Error {
    case invalidURL
    case jsonParsingFailed
    case sslError
    case invalidResponse
    case noData
    case invalidRequest
    case invalidResponseCode(Int)
    case clientError(Int)
    case serverError(Int)
}

