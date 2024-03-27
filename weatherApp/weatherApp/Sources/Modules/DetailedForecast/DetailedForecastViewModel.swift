//
//  DetailedForecastViewModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 23.03.2024.
//

import Foundation

protocol DetailedForecastVMProtocol {
    func getModel() -> DetailedForecastModel?
}

final class DetailedForecastViewModel: DetailedForecastVMProtocol {
    
    private let weatherModel : DetailedForecastModel?
    
    init(weatherModel: DetailedForecastModel?) {
        self.weatherModel = weatherModel
    }
    
    func getModel() -> DetailedForecastModel? {
        return weatherModel
    }
}
