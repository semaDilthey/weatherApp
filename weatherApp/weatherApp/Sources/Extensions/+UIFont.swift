//
//  +UIFont.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

extension UIFont {
    
    enum C {
        
        enum Poppins: Int {
            case title = 0
            
            var nameFont: String {
                switch self {
                case .title:
                    return "Poppins SemiBold"
                }
            }
        }
        
        enum AvantGarde: Int {
            case small = 0
            case medium = 1
            case title = 2
            
            var nameFont: String {
                switch self {
                case .small:
                    return "ITCAvantGardeStd-XLtCnObl"
                case .medium:
                    return "ITCAvantGardeStd-BkCn"
                case .title:
                    return "ITCAvantGardeStd-Demi"
                }
            }
        }
        
        static func poppins(size fontSize: CGFloat, weight fontWeight: Poppins) -> UIFont? {
            UIFont(name: fontWeight.nameFont, size: fontSize)
        }
        
        static func avantGarge(size fontSize: CGFloat, weight fontWeight: AvantGarde) -> UIFont? {
            UIFont(name: fontWeight.nameFont, size: fontSize)
        }
    }
}
