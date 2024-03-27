//
//  WeatherCardModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 23.03.2024.
//

import Foundation

protocol WCardModelProtocol {
    var iconURL : URL? { get set }
    var condition: String { get set }
    var temp : String { get set }
    var tempFeelsLike : String { get set }
    var wind : String { get set }
    var pressure : String { get set }
    var visibility : String { get set }
}

struct WeatherCardModel : WCardModelProtocol {
    var iconURL: URL?
    
    var condition: String
    
    var temp: String
    
    var tempFeelsLike: String
    
    var wind: String
    
    var pressure: String
    
    var visibility: String
    
    init(iconURL: String, condition: String, temp: Double, tempFeelsLike: Double, wind: Double, pressure: Double, visibility: Int) {
        self.condition = condition
        self.temp = String(temp.rounded(toPlaces: 1))
        self.tempFeelsLike = String(tempFeelsLike.rounded(toPlaces: 1))
        self.wind = String(wind.rounded(toPlaces: 1))
        self.pressure = String(pressure.rounded(toPlaces: 1))
        self.visibility = String(visibility)
        
        self.iconURL = URL(string: iconURL)
    }
}
