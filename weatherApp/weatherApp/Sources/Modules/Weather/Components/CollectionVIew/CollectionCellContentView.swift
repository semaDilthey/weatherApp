//
//  WeatherCellContentView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit
import SnapKit
import Foundation
import Kingfisher

fileprivate enum ColCelCOnstants {
    static let dateFontSize : CGFloat = 34
    static let dayFontSize : CGFloat = 16
    static let imageMultiplier : CGFloat = 0.32

}

final class CollectionCellContentView : BaseView {
    
    private let conditionImage = UIImageView()
    private let dateLabel = UILabel()
    private let dayLabel = UILabel()
    
    var isSelected: Bool = false {
        didSet {
            listenState(isSelected: isSelected)
        }
    }
    
    public func prepareForReuse() {
        conditionImage.image = nil
        dateLabel.text = ""
        dayLabel.text = ""
    }
    
    #warning("Вообще косякнул что стал передавать готовую строку а не Date. Еще через модели надо возвращать Date а трансформить как надо уже тутс")
    public func set(with model: WCollectionCellModelProtocol?) {
        guard let model else { return }
        conditionImage.kf.setImage(with: model.conditionImageURL)
        if let date = model.date {
            dateLabel.text = String(date.prefix(2))
            
            let result : [String] = date.components(separatedBy: " ")
            dayLabel.text =  String(result[1].prefix(3))
        }
    }
    
    private func configConditionImage() {
        conditionImage.contentMode = .scaleAspectFit
    }
    
    private func configDateLabel(){
        dateLabel.textColor = C.Colors.text
        dateLabel.font = UIFont.C.avantGarge(size: ColCelCOnstants.dateFontSize, weight: .title)
    }
    
    private func configDayLabel(){
        dayLabel.textColor = C.Colors.text
        dayLabel.font = UIFont.C.avantGarge(size: ColCelCOnstants.dayFontSize, weight: .title)
    }
    
    private func listenState(isSelected: Bool) {
        if isSelected {
            dateLabel.textColor = C.Colors.accentPurple
            dayLabel.textColor = C.Colors.accentPurple
        } else {
            dateLabel.textColor = C.Colors.text
            dayLabel.textColor = C.Colors.text
        }
    }
}

extension CollectionCellContentView {
    
    override func configureAppearance() {
        configConditionImage()
        configDateLabel()
        configDayLabel()
    }
    
    override func addSubviews() {
        addSubview(conditionImage)
        addSubview(dateLabel)
        addSubview(dayLabel)
    }
    
    override func layoutConstraints() {

        conditionImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(C.Offset.small)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(ColCelCOnstants.imageMultiplier)
            make.width.equalTo(snp.height).multipliedBy(ColCelCOnstants.imageMultiplier)
            
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(snp_centerYWithinMargins)
            make.centerX.equalToSuperview()
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.centerX.equalToSuperview()
        }
    }
}
