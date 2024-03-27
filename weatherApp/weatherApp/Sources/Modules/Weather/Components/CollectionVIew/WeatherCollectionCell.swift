//
//  WeatherCell.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit
import SnapKit

private extension String {
    static let identifier = "WeatherCollectionCell"
}

final class WeatherCollectionCell: UICollectionViewCell {
    
    static let identifier : String = .identifier
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    override var isSelected: Bool {
        didSet {
            listenState()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        innerView?.prepareForReuse()
    }
        
    private var containerView = UIView()
    private var innerView : CollectionCellContentView?
    
    public func setView(with model: WCollectionCellModelProtocol?) {
        guard let model else { return }
        innerView = CollectionCellContentView()
        innerView?.set(with: model)
        
        if let innerView {
            containerView.addSubview(innerView)
            innerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }

    
    private func listenState() {
        guard let innerView else { return }
        if isSelected {
            innerView.isSelected = true
            UIView.animate(withDuration: 0.3) {
                dropShadow(on: self.contentView, drop: true)
            }
        } else {
            innerView.isSelected = false
            UIView.animate(withDuration: 0.3) {
                dropShadow(on: self.contentView, drop: false)
            }
        }
    }
}

extension WeatherCollectionCell {
    
    private func configureAppearance() {
        containerView.backgroundColor = C.Colors.card
        containerView.layer.cornerRadius = contentView.frame.width/2
        containerView.clipsToBounds = true
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    private func layoutConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
}
