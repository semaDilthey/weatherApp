//
//  +DateFormatter.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 20.03.2024.
//

import Foundation

private extension String {
    static let incomingFormat : String = "yyyy-MM-dd HH:mm:ss"
}

extension DateFormatter {
    
    enum Formats : String {
        case short = "ddMMM"
        case long = "ddMMM, EEEE"
    }
        
    func string(from date: String, format: Formats) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = .incomingFormat

        guard let inputDate = dateFormatter.date(from: date) else {
           return ""
        }

        self.dateFormat = format.rawValue
        return self.string(from: inputDate)
    }
    
    
}
