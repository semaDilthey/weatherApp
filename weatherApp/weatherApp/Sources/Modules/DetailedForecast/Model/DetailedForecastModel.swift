//
//  DetailedForecastModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 27.03.2024.
//

import Foundation

struct DetailedForecastModel {
    var city : String
    var date : String?
    var conditions : String
    var imageURL : URL?
    var temp : String
    var feelsLikeTemp : String
    var minTemp : String
    var maxTemp : String
    var pressure : String
    var visibility : String
    var wind : String
    
    init(city: String, date: String?, conditions: String, imageString: String, temp: Double, feelsLikeTemp: Double, minTemp: Double, maxTemp: Double, pressure: Double, visibility: Int, wind: Double) {
        self.city = city
        self.date = date
        self.conditions = conditions
        self.imageURL = URL(string: imageString)
        self.temp = String(temp.rounded(toPlaces: 1)) + " " + C.Strings.celcius
        self.feelsLikeTemp = String(feelsLikeTemp.rounded(toPlaces: 1)) + " " + C.Strings.celcius
        self.minTemp = String(minTemp.rounded(toPlaces: 1)) + " " + C.Strings.celcius
        self.maxTemp = String(maxTemp.rounded(toPlaces: 1)) + " " + C.Strings.celcius
        self.pressure = String(pressure.rounded(toPlaces: 1)) + " Pa"
        self.visibility = String(visibility) + " m"
        self.wind = String(wind.rounded(toPlaces: 1)) + " m/s"
    }
}
