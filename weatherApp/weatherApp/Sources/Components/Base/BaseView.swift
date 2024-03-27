//
//  BaseView.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

public class BaseView : UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

@objc extension BaseView {
    
    func configureAppearance() {}
    
    func addSubviews() {}
    
    func layoutConstraints() {}
}
