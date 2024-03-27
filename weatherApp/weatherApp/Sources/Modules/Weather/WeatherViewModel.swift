//
//  WeatherViewModel.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import Foundation
import RxSwift
import RxRelay
import UIKit

private extension String {
    static let defaultCity = "New york"
}

protocol WMainProtocol: AnyObject {
    var weatherModel : BehaviorRelay<WeatherModel?> { get set }
    func loadUserLocation() throws
    func getWeather(for city: String)
    func numberOfItems() -> Int
    func presentDetailedForecast(_ navController : UINavigationController?, at indexPath: IndexPath)
}

protocol WModelsProtocol {
    func getTableCellModel(at: IndexPath) -> WTableCellModelProtocol?
    func getCollectionCellModel(at indexPath: IndexPath) -> WCollectionCellModelProtocol?
    func getWeatherCardModel(forCellAt indexPath: IndexPath) -> WCardModelProtocol?
}

protocol WVMProtocol: WMainProtocol, WModelsProtocol  {}

final class WeatherViewModel : WVMProtocol {
    
    private let networkManager : Networking
    private let locationManager : LocationManager
    private let disposeBag = DisposeBag()
    
    init(networkManager: Networking = NetworkManager(), locationManager : LocationManager = LocationManager.shared) {
        self.networkManager = networkManager
        self.locationManager = locationManager
        bindRelay()
        listenLocationAuthStatus()
    }
    
    //MARK: - WeatherMainProtocol
    
    public var weatherModel = BehaviorRelay<WeatherModel?>(value: nil)

    func loadUserLocation() throws {
        guard locationManager.isAuthorised() else {
                getWeather(for: .defaultCity)
                throw LocationError.authorizationDenied
            }
        fetchUserLocation()
    }

    func getWeather(for city: String) {
        networkManager.fetchWeather(for: city)
    }
    
    func numberOfItems() -> Int {
        guard let weather = weatherModel.value else { return 0 }
        return weather.filteredList.count
    }
    
    func presentDetailedForecast(_ navController : UINavigationController?, at indexPath: IndexPath) {
        guard let navController else { return }
        guard let model = getDetailsForecastModel(at: indexPath) else { return }
        let viewModel = DetailedForecastViewModel(weatherModel: model)
        let vc = DetailedForecastViewController(viewModel: viewModel)
        navController.pushViewController(vc, animated: true)
    }

    //MARK: - Private methods
    
    private func listenLocationAuthStatus() {
            self.locationManager.locationAuthCallback = { [weak self] isAuth in
                // обновляем модель данных, если разрешение получено
                if isAuth {
                    self?.fetchUserLocation()
                }
            }
        }
    
    private func setWeather(from data: WeatherData) -> WeatherModel? {
        return WeatherModel(cityName: data.city.name, list: data.list)
    }
    

    private func fetchUserLocation() {
        locationManager.requestLocation { [weak self] location in
            self?.networkManager.fetchWeather(for: location)
        }
    }
    
    private func bindRelay() {
        networkManager.relay
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success(let weatherData):
                    let weatherModel = self?.setWeather(from: weatherData)
                    self?.weatherModel.accept(weatherModel)
                case .failure(let error):
                    print(error)
                }
        })
            .disposed(by: disposeBag)
    }
    
    private func getDetailsForecastModel(at indexPath: IndexPath) -> DetailedForecastModel? {
        guard let weather = weatherModel.value,
                indexPath.row < weather.filteredList.count else { return nil }
        let iconString = self.fetchImageURL(for: indexPath)
        return DetailedForecastModel(city: weather.name,
                                     date: weather.date(for: indexPath, format: .long),
                                     conditions: weather.conditionName(for: indexPath),
                                     imageString: iconString,
                                     temp: weather.filteredList[indexPath.row].main.temp,
                                     feelsLikeTemp: weather.filteredList[indexPath.row].main.feelsLike,
                                     minTemp: weather.minTemp(for: indexPath),
                                     maxTemp: weather.maxTemp(for: indexPath),
                                     pressure: weather.filteredList[indexPath.row].main.pressure,
                                     visibility: weather.filteredList[indexPath.row].visibility,
                                     wind: weather.filteredList[indexPath.row].wind.speed)
    }
}

//MARK: - WeatherTableProtocol
extension WeatherViewModel {
    
    func getTableCellModel(at indexPath: IndexPath) -> WTableCellModelProtocol? {
        guard let weather = weatherModel.value else { return nil }
        let iconURL = self.fetchImageURL(for: indexPath)
        return WeatherTableCellModel(date: weather.date(for: indexPath, format: .long) ?? "21",
                                     minTemp: weather.minTemp(for: indexPath),
                                     maxTemp: weather.maxTemp(for: indexPath),
                                     conditionImageURL: iconURL,
                                     conditionName: weather.conditionName(for: indexPath))
    }
    
    private func fetchImageURL(for indexPath: IndexPath) -> String {
        guard let weatherList = weatherModel.value?.filteredList,
                indexPath.row < weatherList.count else { return ""}
        
        let iconForCondition = weatherList[indexPath.row].weather[0].icon
        let iconURL = networkManager.getStringForIcon(for: iconForCondition)
        return iconURL
    }
    
}


//MARK: - WeatherCollectionProtocol

extension WeatherViewModel {
    
    func getCollectionCellModel(at indexPath: IndexPath) -> WCollectionCellModelProtocol? {
        guard let weather = weatherModel.value , indexPath.row < weather.filteredList.count else { return nil }
        let iconURL = self.fetchImageURL(for: indexPath)
        return WeatherCollectionCellModel(
            conditionImageString: iconURL,
            date: weather.date(for: indexPath, format: .long)
        )
    }
    
}

extension WeatherViewModel {
    
    func getWeatherCardModel(forCellAt indexPath: IndexPath) -> WCardModelProtocol? {
        guard let weather = weatherModel.value , indexPath.row < weather.filteredList.count else { return nil }
        let iconString = self.fetchImageURL(for: indexPath)
        return WeatherCardModel(iconURL: iconString,
                                condition: weather.conditionName(for: indexPath),
                                temp: weather.filteredList[indexPath.row].main.temp,
                                tempFeelsLike: weather.filteredList[indexPath.row].main.feelsLike,
                                wind: weather.filteredList[indexPath.row].wind.speed,
                                pressure: weather.filteredList[indexPath.row].main.pressure,
                                visibility: weather.filteredList[indexPath.row].visibility
        )
    }
}
