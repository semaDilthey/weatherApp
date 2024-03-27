//
//  Weather.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation

struct WeatherData: Codable {
    let cod: String
    let list: [List]
    let city: City
}

// MARK: - List
struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let snow: Snow?
    let dtTxt: String
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord
    let country: String
    let population, timezone, sunrise, sunset: Int
}

struct Main : Codable {
    let temp : Double
    let feelsLike : Double
    let tempMin : Double
    let tempMax : Double
    let pressure : Double
}

struct Weather : Codable {
    let id : Int
    let main : String
    let icon : String
    let description : String
}

struct Wind : Codable {
    let speed : Double
}

// MARK: - Coord
struct Coord: Codable {
    let lat, lon: Double
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Snow
struct Snow: Codable {
    let the3H: Double
    
    enum CodingKeys: String, CodingKey {
            case the3H = "3h"
        }
}
