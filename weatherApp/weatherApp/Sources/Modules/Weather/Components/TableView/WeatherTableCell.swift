//
//  WeatherTableCell.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 18.03.2024.
//

import UIKit

private extension String {
    static let identifier = "WeatherTableCell"
    
}

final class WeatherTableCell : UITableViewCell {
    
    static let identifier : String = .identifier
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        innerView?.prepareForReuse()
    }
    
    private var containerView = UIView()
    private var innerView : TableCellContentView?

    public func setView(with model: WTableCellModelProtocol?) {
        guard let model else { return }
        innerView = TableCellContentView()
        innerView?.set(with: model)
        
        if let innerView {
            containerView.addSubview(innerView)
            innerView.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
}


extension WeatherTableCell {
    
    private func configureAppearance() {
        containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 10
        containerView.clipsToBounds = true
        dropShadow(on: contentView, drop: true)
    }
    
    private func addSubviews() {
        contentView.addSubview(containerView)
    }
    
    private func layoutConstraints() {
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(C.Offset.small)
            make.bottom.equalToSuperview().inset(C.Offset.small)
            make.leading.equalToSuperview().offset(C.Offset.medium)
            make.trailing.equalToSuperview().inset(C.Offset.medium)
        }
    }
    
}
