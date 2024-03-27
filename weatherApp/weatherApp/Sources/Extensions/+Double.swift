//
//  +Double.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 23.03.2024.
//

import Foundation

// Округляет значение до нужнго числа после запятой
extension Double {
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
}
