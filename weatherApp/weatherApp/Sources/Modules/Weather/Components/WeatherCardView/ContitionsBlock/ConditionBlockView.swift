//
//  ConditionBlockView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 18.03.2024.
//

import UIKit
import SnapKit

private extension CGFloat {
    static let cornerRadius : CGFloat = 16
}

final class ConditionBlockView : BaseView {
    
    private let containerView = UIView()
    private let conditionImage = UIImageView()
    private let textLabel = UILabel()
    
    public func configure(with condition: String, image: UIImage?) {
        textLabel.text = condition
        if let image {
            conditionImage.image = image
        }
    }
    
    private func configureContainer() {
        containerView.backgroundColor = C.Colors.card
        containerView.layer.cornerRadius = .cornerRadius
        containerView.clipsToBounds = true
    }
    
    private func configureImage() {
        conditionImage.contentMode = .scaleAspectFit
        conditionImage.image = C.Image.wind
    }
    
    private func configureLabel() {
        textLabel.font = UIFont.C.avantGarge(size: 16, weight: .medium)
        textLabel.textColor = C.Colors.text
    }
}

extension ConditionBlockView {
    
    override func configureAppearance() {
        configureContainer()
        configureImage()
        configureLabel()
    }
    
    override func addSubviews() {
        addSubview(containerView)
        containerView.addSubview(conditionImage)
        addSubview(textLabel)
    }
    
    override func layoutConstraints() {
        containerView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.9)
        }
        
        conditionImage.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(C.Offset.small)
            make.trailing.bottom.equalToSuperview().inset(C.Offset.small)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(C.Offset.small)
            make.centerX.equalToSuperview()
        }
    }
}
//
//@available(iOS 17.0, *)
//#Preview {
//    let ConditionBlockView = ConditionBlockView()
//        return ConditionBlockView
//}
