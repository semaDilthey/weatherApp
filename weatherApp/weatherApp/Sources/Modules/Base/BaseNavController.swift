//
//  BaseNavController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 27.03.2024.
//

import Foundation
import UIKit

class BaseNavController : UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.backgroundColor = C.Colors.background
        navBarAppearance.shadowColor = C.Colors.background

        navigationBar.standardAppearance = navBarAppearance
        navigationBar.scrollEdgeAppearance = navBarAppearance
        navigationBar.isTranslucent = false
    }
}
