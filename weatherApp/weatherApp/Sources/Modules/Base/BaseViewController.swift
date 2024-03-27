//
//  BaseViewController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 17.03.2024.
//

import UIKit

//MARK: - Interface
@objc protocol BaseInterface : AnyObject {
    func configure()
    
    func configureAppearance()
    func addSubviews()
    func layoutConstraints()
    
    func startAnimations()
    func stopAnimations()
    
    func saveDataBeforeDisappear()
}


//MARK: - Realization
public class BaseViewController : UIViewController {
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureAppearance()
        addSubviews()
        layoutConstraints()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimations()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopAnimations()
        saveDataBeforeDisappear()
    }
    
}

//MARK: - Extension
extension BaseViewController: BaseInterface {
    
    public func configure() {}
    
    public func configureAppearance() {
        view.backgroundColor = C.Colors.background
    }
    public func addSubviews() {}
    public func layoutConstraints() {}
    
    public func startAnimations() {}
    public func stopAnimations() {}
    
    public func saveDataBeforeDisappear() {}
}
