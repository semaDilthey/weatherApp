//
//  OnboardingViewController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 19.03.2024.
//

import UIKit
import SnapKit

final class OnboardingViewController : BaseViewController {
    
    private let viewModel : OnboardingVMProtocol
    
    init(viewModel: OnboardingVMProtocol = OnboardingViewModel()) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let imageView = UIImageView()
    private let onboardingCard = OnboardingCard()
    
    private func configImageView() {
        imageView.contentMode = .scaleAspectFit
        imageView.image = C.Image.visibility
    }
    
    private func configOnboardingCard() {
        dropShadow(on: onboardingCard, drop: true)
        onboardingCard.layer.cornerRadius = 24
        onboardingCard.delegate = self
    }
}

extension OnboardingViewController {
    
    override func configureAppearance() {
        view.backgroundColor = .white
        configImageView()
        configOnboardingCard()
    }
    
    override func addSubviews() {
        view.addSubview(imageView)
        view.addSubview(onboardingCard)
    }
    
    override func layoutConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(view.frame.height*0.12)
            make.leading.equalToSuperview().offset(C.Offset.big)
            make.trailing.equalToSuperview().inset(C.Offset.big)
            make.height.equalTo(view.frame.height*0.35)
        }
        
        onboardingCard.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(80)
            make.leading.equalToSuperview().offset(C.Offset.big)
            make.trailing.equalToSuperview().inset(C.Offset.big)
            make.bottom.equalToSuperview().inset(view.frame.height*0.042)
        }
    }
}

extension OnboardingViewController : OnboardingDelegate {
    
    func getStarted() {
        print("getStarted")

        viewModel.setFirstLaunch()
        viewModel.presentWeatherVC(navigationController)
        
    }
}
