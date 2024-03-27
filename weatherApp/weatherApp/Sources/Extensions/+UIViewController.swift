//
//  +UIViewController.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 20.03.2024.
//

import UIKit


extension UIViewController {
    
    // По клику по любой точке на экране отменяет клавиатуру; Чезер action добавляем доп настройки
    func setupToHideKeyboardOnTapOnView(action: Selector?)
    {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: action)

        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard(action: (()->()))
    {
        view.endEditing(true)
        
    }
}
