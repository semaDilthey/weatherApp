//
//  WeatherCardView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 18.03.2024.
//

import Foundation
import UIKit
import Kingfisher

//MARK: - private extensions and enums

private extension UIColor {
    static let background = UIColor(hexString: "#80AFFE")
}

private extension String {
    static let feelsLike = "Feels like "
}

private enum TextSize {
    case small, medium, big
    
    var size : CGFloat {
        switch self {
        case .small:
            return 18
        case .medium:
            return 26
        case .big:
            return 58
        }
    }
}

private enum ConditionCards {
    case visibility, wind, pressure
    
    var image : UIImage? {
        switch self {
        case .visibility:
            return C.Image.visibility
        case .wind:
            return C.Image.wind
        case .pressure:
            return C.Image.pressure
        }
    }
}

//MARK: - View

final class WeatherCardView: BaseView {
    
    //MARK:  UI Elements

    private var conditionImage = UIImageView()
    private let conditionName = UILabel()
    private let temperature = UILabel()
    private let temperatureFeelsLike = UILabel()
    
    private let visibilityView = ConditionBlockView()
    private let windView = ConditionBlockView()
    private let pressureView = ConditionBlockView()
    
    //MARK:  Public methods

    public func configure(with model: WCardModelProtocol?) {
        guard let model else { return }
        conditionImage.kf.setImage(with: model.iconURL)
        conditionName.text = model.condition
        temperature.text = model.temp + C.Strings.celcius
        temperatureFeelsLike.text = .feelsLike + model.tempFeelsLike + C.Strings.celcius
        visibilityView.configure(with: model.visibility + " " + C.Strings.visibility,
                                 image: ConditionCards.visibility.image)
        windView.configure(with: model.wind + " " + C.Strings.windSpeed,
                           image: ConditionCards.wind.image)
        pressureView.configure(with: model.pressure + " " + C.Strings.pressure,
                               image: ConditionCards.pressure.image)
    }
    
    //MARK:  Private methods

    private func configConditionAnimation() {
        conditionImage.tintColor = .red
        conditionImage.contentMode = .scaleAspectFit
        dropShadow(on: conditionImage, drop: true)
    }
    
    private func configConditionName() {
        conditionName.textColor = C.Colors.text
        conditionName.adjustsFontSizeToFitWidth = true
        conditionName.font = UIFont.C.avantGarge(size: TextSize.medium.size, 
                                                 weight: .title)
    }
    
    private func configTemperature() {
        temperature.textColor = C.Colors.text
        temperature.adjustsFontSizeToFitWidth = true
        temperature.font = UIFont.C.avantGarge(size: TextSize.big.size, 
                                               weight: .title)
    }
    
    private func configTemperatureFeelsLike() {
        temperatureFeelsLike.textColor = C.Colors.text
        temperatureFeelsLike.adjustsFontSizeToFitWidth = true
        temperatureFeelsLike.font = UIFont.C.avantGarge(size: TextSize.small.size, 
                                                        weight: .title)
        temperatureFeelsLike.textAlignment = .right
    }
}

//MARK: - Overriding parent methods

extension WeatherCardView {
    
    override func configureAppearance() {
        backgroundColor = .background
        dropShadow(on: self, drop: true)
        configConditionAnimation()
        configConditionName()
        configTemperature()
        configTemperatureFeelsLike()
    }
    
    override func addSubviews() {
        addSubview(conditionImage)
        addSubview(conditionName)
        addSubview(temperature)
        addSubview(temperatureFeelsLike)
        
       
    }
    
    override func layoutConstraints() {
        conditionImage.snp.makeConstraints { make in
            make.centerY.equalTo(frame.origin.x+10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalToSuperview().multipliedBy(0.4)
        }
        
        conditionName.snp.makeConstraints { make in
            make.top.equalTo(conditionImage.snp.bottom).offset(C.Offset.big)
            make.leading.equalToSuperview().offset(C.Offset.medium)
            make.width.equalToSuperview().multipliedBy(0.44)
        }
        
        temperature.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(C.Offset.medium)
            make.trailing.equalToSuperview().inset(C.Offset.medium)
        }
        
        temperatureFeelsLike.snp.makeConstraints { make in
            make.leading.equalTo(temperature.snp.leading)
            make.top.equalTo(temperature.snp.bottom).offset(C.Offset.small)
            make.trailing.equalToSuperview().inset(C.Offset.medium)
        }
        
        let conditions = UIStackView(arrangedSubviews: [visibilityView, windView, pressureView])
        conditions.axis = .horizontal
        conditions.distribution = .fillEqually
        conditions.spacing = C.Offset.big
        addSubview(conditions)
        
        conditions.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(C.Offset.medium)
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.height.equalToSuperview().multipliedBy(0.25)
            make.bottom.equalToSuperview().inset(C.Offset.big)
        }
    }
}
//
//@available(iOS 17.0, *)
//#Preview {
//    let WeatherCardView = WeatherCardView()
//        return WeatherCardView
//}
