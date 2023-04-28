//
//  LanguageManager.swift
//  4INSHIELD
//
//  Created by iheb mbarki on 13/3/2023.
//

import Foundation

class LanguageManager {
    static let shared = LanguageManager()
    
    var currentLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: "selectedLanguage") ?? "fr"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "selectedLanguage")
            UserDefaults.standard.synchronize()
        }
    }
    
    private init() {}

}


