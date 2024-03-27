//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

struct WeatherModel {
    
    private let cityName : String
    private let list: [List]
    
    init(cityName: String, list: [List]) {
        self.cityName = cityName
        self.list = list
        self.name = cityName
    }
    
    public var filteredList: [List] {
        return list.filter { self.isNoon(dtTxt: $0.dtTxt)}
    }
    
    public var name : String
    
    func conditionName(for indexPath: IndexPath) -> String {
        guard indexPath.row < filteredList.count else { return "Wrong" }
        return filteredList[indexPath.row].weather[0].main
    }
    
    func minTemp(for indexPath: IndexPath) -> Double {
        guard indexPath.row < filteredList.count else { return 0 }
        return filteredList[indexPath.row].main.tempMin
    }
    
    func maxTemp(for indexPath: IndexPath) -> Double {
        guard indexPath.row < filteredList.count else { return 0 }
        return filteredList[indexPath.row].main.tempMax
    }
    
    func date(for indexPath: IndexPath, format: DateFormatter.Formats) -> String? {
        let dtTxt = self.filteredList[indexPath.row].dtTxt
        let dateForCell = DateFormatter().string(from: dtTxt, format: format)
        return isNoon(dtTxt: dtTxt) ? dateForCell : (Date.now.description)
    }
}


extension WeatherModel {
    
    private func isNoon(dtTxt: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        if let date = dateFormatter.date(from: dtTxt) {
            let hour = Calendar.current.component(.hour, from: date)
            return hour == 12
        }
        return false
    }
    
}

