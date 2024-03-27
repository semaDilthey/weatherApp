//
//  Networking.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import CoreLocation
import RxRelay
import RxSwift

protocol Networking: AnyObject {
    var relay: PublishRelay<Result<WeatherData, NetworkError>> { get set }
    
    func fetchWeather(for city: String)
    func fetchWeather(for location: CLLocation)
    func getStringForIcon(for condition: String) -> String
}

final class NetworkManager: Networking {
    typealias WeatherResult = Result<WeatherData, NetworkError>
    
    private let fetchingService: FetchingService<WeatherData>

    public var relay = PublishRelay<WeatherResult>()
    private let disposeBag = DisposeBag()

    init(fetchingService: FetchingService<WeatherData> = FetchingService()) {
        self.fetchingService = fetchingService
        subscribeOnRelay()
    }

    func fetchWeather(for city: String) {
        let url = Endpoints.getUrl(for: city)
        do {
            try fetchingService.getData(from: url)
        } catch let error {
            self.relay.accept(.failure(error as! NetworkError))
        }
    }

    func fetchWeather(for location: CLLocation) {
        let url = Endpoints.getUrl(for: location)
        do {
            try fetchingService.getData(from: url)
        } catch let error {
            self.relay.accept(.failure(error as! NetworkError))
        }
    }
    
    func getStringForIcon(for condition: String) -> String {
        return Endpoints.getIconURL(for: condition)
    }
}

extension NetworkManager {
    
    private func subscribeOnRelay() {
        self.fetchingService.relay.subscribe(onNext: { [weak self] result in
            self?.relay.accept(result)
        })
        .disposed(by: disposeBag)
    }
    
}
