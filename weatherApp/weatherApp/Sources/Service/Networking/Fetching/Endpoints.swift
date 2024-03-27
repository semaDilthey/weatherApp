//
//  Endpoints.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 16.03.2024.
//

import Foundation
import CoreLocation

private extension String {
    static let apiKey = "1b630eb4bfd90ee672bb87752a9c419d"
}

enum Endpoints {

    static private let units = "metric"
    
    static var baseURL : String {
        return "https://api.openweathermap.org/data/2.5/forecast?appid=" + .apiKey + "&units=" + units
    }
    
    static let iconURL = "https://openweathermap.org/img/wn/"
    
}

extension Endpoints {
    
    // url for city
    static func getUrl(for city: String) -> String {
        return baseURL + "&q=\(city)"
    }
    
    // url for location via lon/lat
    static func getUrl(for location: CLLocation) -> String {
        let lon = location.coordinate.longitude
        let lat = location.coordinate.latitude
        return baseURL + "&lon=\(lon)" + "&lat=\(lat)"
    }
    
    // url for downloading icons
    static func getIconURL(for condition: String) -> String {
        return iconURL + condition + "@2x.png"
    }
    
}
