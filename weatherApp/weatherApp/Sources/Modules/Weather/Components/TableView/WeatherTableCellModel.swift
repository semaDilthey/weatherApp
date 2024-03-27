//
//  WeatherTableCellModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 20.03.2024.
//

import UIKit

protocol WTableCellModelProtocol {
    var date: String { get set }
    var minTemp: String { get set }
    var maxTemp: String { get set }
    var conditionImageURL: URL? { get set }
    var conditionName: String { get set }
}

struct WeatherTableCellModel: WTableCellModelProtocol {
    var date: String
    
    var minTemp: String
    
    var maxTemp: String
    
    var conditionImageURL: URL?
    
    var conditionName: String
    
    init(date: String, minTemp: Double, maxTemp: Double, conditionImageURL: String, conditionName: String) {
        self.date = date
        self.minTemp = String(minTemp.rounded(toPlaces: 1))
        self.maxTemp = String(maxTemp.rounded(toPlaces: 1))
        if let url = URL(string: conditionImageURL) {
            self.conditionImageURL = url
        }
        self.conditionName = conditionName
    }
}
