//
//  SharedVariables.swift
//  4INSHIELD
//
//  Created by kaisensData on 25/8/2023.
//

import Foundation

class SharedVariables {
    static let shared = SharedVariables()

    var wizzard: Int = 0
    var variable2: String = ""

    private init() {
        // Private init to prevent direct instantiation
    }
}
