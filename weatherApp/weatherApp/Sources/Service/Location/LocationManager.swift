//
//  LocationManager.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation
import CoreLocation
import RxRelay

final class LocationManager : NSObject {
    
    static let shared = LocationManager()
    public var locationAuthCallback: ((Bool) -> Void)?
    
    override private init() {
        super.init()
        locationManager.delegate = self
    }
    
    private lazy var locationManager: CLLocationManager = {
            let manager = CLLocationManager()
            manager.desiredAccuracy = kCLLocationAccuracyBest
            return manager
        }()
    
    func isAuthorised() -> Bool {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            return false
        case .restricted:
            return false
        case .denied:
            return false
        case .authorizedAlways:
            return true
        case .authorizedWhenInUse:
            return true
        case .authorized:
            return true
        @unknown default:
            fatalError()
        }
    }
    
    func requestLocationAuth() {
            switch locationManager.authorizationStatus {
            case .denied, .restricted:
                print("Access had been restrickted. Allow access in settings and try again")
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.startUpdatingLocation()
            default:
                locationManager.requestWhenInUseAuthorization()
            }
        }

    // Метод для запроса текущего местоположения с использованием замыкания
       func requestLocation(completion: @escaping (CLLocation) -> Void) {
           // Сохраняем замыкание для дальнейшего вызова
           self.completionHandler = completion
           locationManager.requestLocation()
       }
    
    // Приватное свойство для хранения замыкания
        private var completionHandler: ((CLLocation) -> Void)?
}


extension LocationManager : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        // вызываем замыкание с полученной локацией
        completionHandler?(location)
        // Очищаем замыкание после использования, чтобы избежать утечек памяти
        completionHandler = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways :
            print("authorizedAlways")
            locationAuthCallback?(true)
        case .authorizedWhenInUse :
            print("authorizedWhenInUse")
            locationAuthCallback?(true)
        default :
            print("forbidden")
            locationAuthCallback?(false)
        }
    }
}
