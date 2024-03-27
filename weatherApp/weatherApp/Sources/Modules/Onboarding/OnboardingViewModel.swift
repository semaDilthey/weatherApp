//
//  OnboardingViewModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 19.03.2024.
//

import UIKit

protocol OnboardingVMProtocol {
    func setFirstLaunch()
    func presentWeatherVC(_ navController: UINavigationController?)
}

final class OnboardingViewModel: OnboardingVMProtocol {
    
    private let locationManager : LocationManager
    private let userDefaults = UDManager.shared
    
    init(locationManager: LocationManager = LocationManager.shared) {
        self.locationManager = locationManager
    }
    
    func setFirstLaunch() {
        if userDefaults.isFirstLaunch() {
            locationManager.requestLocationAuth()
            userDefaults.markAsLaunched()
        }
    }
    
    func presentWeatherVC(_ navController: UINavigationController?) {
        guard let navController else { return }
        locationManager.locationAuthCallback = { [weak self] isAuth in
            if isAuth {
                let weatherVM = WeatherViewModel()
                let weatherVC = WeatherViewController(viewModel: weatherVM)
                navController.pushViewController(weatherVC, animated: true)
            }
        }
    }

    
}
