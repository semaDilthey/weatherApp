//
//  DetailedForecastViewController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 23.03.2024.
//

import UIKit
import SnapKit
import Kingfisher

final class DetailedForecastViewController : BaseViewController {
    
    //MARK: - Properties
    
    private let viewModel: DetailedForecastVMProtocol
    
    //MARK: - Init
    
    init(viewModel: DetailedForecastVMProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        print(viewModel.getModel())
    }
    
    //MARK: - UI Elements
    
    private let cityLabel = UILabel()
    private let dateLabel = UILabel()
    private let conditionsLabel = UILabel()
    private let conditionsImage = UIImageView()
    
    private let temperatureLabel = UILabel()
    private let feelsLikeLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    private let pressureLabel = UILabel()
    private let visibilityLabel = UILabel()
    private let windLabel = UILabel()
    
    //MARK: - Private methods
    
    private func configureForecast() {
        guard let model = viewModel.getModel() else {
            print("No weatherModel found")
            return
        }
        
        cityLabel.text = model.city
        dateLabel.text = model.date
        conditionsImage.kf.setImage(with: model.imageURL)
        conditionsLabel.text = model.conditions
        
        temperatureLabel.text = "Current: " + model.temp
        feelsLikeLabel.text = "Feels like: " + model.feelsLikeTemp
        minTempLabel.text = "Min: " + model.minTemp
        maxTempLabel.text = "Max: " + model.maxTemp
        
        pressureLabel.text = "Pressure: " + model.pressure
        visibilityLabel.text = "Visibility: " + model.visibility
        windLabel.text = "Wind: " + model.wind
        
    }
}


extension DetailedForecastViewController {
    
    override func configureAppearance() {
        super.configureAppearance()
        configureForecast()
    }
    
    override func layoutConstraints() {
        
        let stack = UIStackView(arrangedSubviews: [cityLabel, dateLabel, conditionsImage, conditionsLabel, temperatureLabel, feelsLikeLabel, minTempLabel, maxTempLabel, pressureLabel, visibilityLabel, windLabel])
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
        }
    }
}
