//
//  OnboardingCard.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 19.03.2024.
//

import UIKit

private enum OnboardingParams {
    enum Title {
        static let fontSize :CGFloat = 42
        static let titleText = "Aston weather"
    }
    enum Subtitle {
        static let fontSize :CGFloat = 20
        static let subtitleText = "Planning your day become more easily with Aston Weather app. You can instantly look for the whole world weather withing few seconds"
    }
    enum Button {
        static let fontSize : CGFloat = 24
        static let buttonText = "Get started"
        static let cornerRadius :CGFloat = 10
        static let multiplier : CGFloat = 0.15
    }
}

protocol OnboardingDelegate : AnyObject {
    func getStarted()
}

final class OnboardingCard : BaseView {
    
    weak var delegate : OnboardingDelegate?
    
    private let titleeLabel = UILabel()
    private let subtitleLabel = UILabel()
    private lazy var getStartedButton = UIButton()
    
    private func configTitle() {
        titleeLabel.textColor = C.Colors.text
        titleeLabel.font = UIFont.C.poppins(size: OnboardingParams.Title.fontSize, 
                                            weight: .title)
        titleeLabel.text = OnboardingParams.Title.titleText
        titleeLabel.numberOfLines = 0
        titleeLabel.lineBreakMode = .byWordWrapping
        titleeLabel.textAlignment = .center
    }
    
    private func configSubtitle() {
        subtitleLabel.textColor = C.Colors.text
        subtitleLabel.font = UIFont.C.avantGarge(size: OnboardingParams.Subtitle.fontSize, 
                                                 weight: .medium)
        subtitleLabel.text = OnboardingParams.Subtitle.subtitleText
        subtitleLabel.numberOfLines = 0
        subtitleLabel.lineBreakMode = .byWordWrapping
        subtitleLabel.textAlignment = .center
    }
    
    private func configButton() {
        getStartedButton.backgroundColor = C.Colors.accentPurple
        getStartedButton.layer.cornerRadius = OnboardingParams.Button.cornerRadius
        getStartedButton.setTitle(OnboardingParams.Button.buttonText, 
                                  for: .normal)
        getStartedButton.titleLabel?.font = UIFont.C.avantGarge(size: OnboardingParams.Button.fontSize,
                                                                weight: .medium)
        getStartedButton.titleLabel?.textAlignment = .center
        getStartedButton.animateTouch(getStartedButton)
        getStartedButton.addTarget(self, action: #selector(didTappedButton), for: .touchUpInside)
    }
    
    @objc private func didTappedButton() {
        delegate?.getStarted()
    }
    
}

extension OnboardingCard {
    
    override func configureAppearance() {
        backgroundColor = C.Colors.card
        configTitle()
        configSubtitle()
        configButton()
    }

    override func addSubviews() {
        addSubview(titleeLabel)
        addSubview(subtitleLabel)
        addSubview(getStartedButton)
    }
    
    override func layoutConstraints() {
        
        titleeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(C.Offset.big)
            make.leading.equalToSuperview().offset(C.Offset.big)
            make.trailing.equalToSuperview().inset(C.Offset.big)
        }
        
        subtitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(titleeLabel.snp.bottom).offset(C.Offset.big)
            make.leading.equalToSuperview().offset(C.Offset.big)
            make.trailing.equalToSuperview().inset(C.Offset.big)
        }
        
        getStartedButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(C.Offset.medium)
            make.trailing.equalToSuperview().inset(C.Offset.medium)
            make.bottom.equalToSuperview().inset(C.Offset.big)
            make.height.equalToSuperview().multipliedBy(OnboardingParams.Button.multiplier)
        }
    }
}
