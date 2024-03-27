//
//  TableCellContentView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 18.03.2024.
//

import UIKit
import Kingfisher

final class TableCellContentView : BaseView {
    
    private let dateLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    private let conditionImage = UIImageView()
    private let conditionLabel = UILabel()

    
    public func set(with model: WTableCellModelProtocol?) {
        guard let model else { return }
        dateLabel.text = model.date
        minTempLabel.text = model.minTemp + C.Strings.celcius
        maxTempLabel.text = "/ " + model.maxTemp + C.Strings.celcius
        conditionLabel.text = model.conditionName
        conditionImage.kf.setImage(with: model.conditionImageURL)
    }
    
    public func prepareForReuse() {
        dateLabel.text = ""
        minTempLabel.text = ""
        maxTempLabel.text = ""
        conditionImage.image = nil
        conditionLabel.text = ""
    }
    
    private func configDateLabel() {
        dateLabel.textColor = C.Colors.background
        dateLabel.font = UIFont.C.avantGarge(size: 16, weight: .title)
    }
    
    private func configMinTempLabel() {
        minTempLabel.textColor = C.Colors.weakText
        minTempLabel.font = UIFont.C.avantGarge(size: 24, weight: .title)
    }
    
    private func configMaxTempLabel() {
        maxTempLabel.textColor = C.Colors.weakText
        maxTempLabel.font = UIFont.C.avantGarge(size: 20, weight: .title)
    }
    
    private func configConditionImage() {
        conditionImage.contentMode = .scaleAspectFit
    }
    
    private func configcConditionLabel() {
        conditionLabel.textColor = C.Colors.accentPurple
        conditionLabel.font = UIFont.C.avantGarge(size: 12, weight: .title)
    }
}

extension TableCellContentView {
    
    override func configureAppearance() {
        configDateLabel()
        configMinTempLabel()
        configMaxTempLabel()
        configConditionImage()
        configcConditionLabel()
    }
    
    override func addSubviews() {
        addSubview(dateLabel)
        addSubview(minTempLabel)
        addSubview(maxTempLabel)
        addSubview(conditionImage)
        addSubview(conditionLabel)
    }
    
    override func layoutConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(C.Offset.small)
        }
        
        minTempLabel.snp.makeConstraints { make in
            let halfOfTheWidth = UIScreen.main.bounds.width/2.3
            make.leading.equalTo(halfOfTheWidth)
            make.centerY.equalToSuperview()
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.leading.equalTo(minTempLabel.snp.trailing)
            make.bottom.equalTo(minTempLabel.snp.bottom)
        }
        
        let conditionStack = UIStackView(arrangedSubviews: [conditionImage, conditionLabel])
        conditionStack.axis = .vertical
        conditionStack.alignment = .center
        conditionStack.distribution = .fillEqually
        
        addSubview(conditionStack)
        conditionStack.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(C.Offset.small)
            make.trailing.equalToSuperview().inset(C.Offset.small)
            make.bottom.equalToSuperview().inset(C.Offset.small)
            make.width.equalTo(60)
        }
    }
}

