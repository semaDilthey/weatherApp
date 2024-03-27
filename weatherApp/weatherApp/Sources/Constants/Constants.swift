//
//  Constants.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

enum C {
    
    enum Colors {
        static let background = UIColor(hexString: "#85B3FE")
        static let card = UIColor(hexString: "#98BEFA")
        static let text = UIColor(hexString: "#FFFFFF")
        static let weakText = UIColor(hexString: "#CDCCCD")
        static let accentPurple = UIColor(hexString: "#7966F8")
    }
    
    enum Offset {
        static let small : CGFloat = 8
        static let medium : CGFloat = 16
        static let big : CGFloat = 24
    }
    
    enum Image {
        static let search = UIImage(named: "magnifying-glass")
        static let wind = UIImage(named: "wind")
        static let visibility = UIImage(named: "visibility")
        static let pressure = UIImage(named: "pressure")

    }
    
    enum Strings {
        static let celcius = "°"
        static let windSpeed = "m/s"
        static let visibility = "m"
        static let pressure = "Pa"
    }
}
