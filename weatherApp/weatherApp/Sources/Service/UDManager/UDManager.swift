//
//  UDManager.swift
//  weatherApp
//
//  Created by Семен Гайдамакин on 19.03.2024.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case isFirstLaunch = "isFirstLaunch"
    
    var key : String {
        return self.rawValue
    }
}

final class UDManager: NSObject {
    
    static let shared = UDManager()
    
    private override init() {
        userDefaults = UserDefaults.standard
    }
    
    private let userDefaults : UserDefaults
    
    // метод для проверки, является ли текущий запуск первым
    func isFirstLaunch() -> Bool {
        return !userDefaults.bool(forKey: UserDefaultsKey.isFirstLaunch.key)
    }
    
    // метод для отметки, что приложение было запущено ранее
    func markAsLaunched() {
        userDefaults.set(true, forKey: UserDefaultsKey.isFirstLaunch.key)
    }
}

