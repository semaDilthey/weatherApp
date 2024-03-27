//
//  LocationError.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 27.03.2024.
//

import Foundation

enum LocationError: Error {
    case authorizationDenied
    case locationNotFound
}
