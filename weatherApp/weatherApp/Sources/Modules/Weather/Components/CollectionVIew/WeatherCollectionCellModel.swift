//
//  WeatherCollectionCellModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 20.03.2024.
//

import UIKit

protocol WCollectionCellModelProtocol {
    var conditionImageURL : URL? { get set }
    var date : String? { get set }

}

struct WeatherCollectionCellModel: WCollectionCellModelProtocol {
    var conditionImageURL: URL?
    var date : String?
    
    init(conditionImageString: String, date: String?) {
        self.conditionImageURL = URL(string: conditionImageString)
        self.date = date
    }
}
